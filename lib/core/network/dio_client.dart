import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';

class DioClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  /// Flag to prevent multiple simultaneous refresh attempts.
  bool _isRefreshing = false;

  /// Queued completers waiting for the token refresh to finish.
  final List<Completer<String>> _pendingCompleters = [];

  DioClient({required this.secureStorage}) : dio = Dio() {
    _configure();
  }

  void _configure() {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': 'ar',
      },
    );

    dio.interceptors.add(_authInterceptor());
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await secureStorage.read(key: StorageKeys.accessToken);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Don't try to refresh if the failing request is the refresh endpoint itself
          final isRefreshRequest =
              error.requestOptions.path.contains(ApiConstants.refreshToken);
          if (isRefreshRequest) {
            await _clearTokensAndLogout();
            return handler.next(error);
          }

          // If already refreshing, queue this request to retry after refresh completes
          if (_isRefreshing) {
            try {
              final completer = Completer<String>();
              _pendingCompleters.add(completer);
              final newToken = await completer.future;

              error.requestOptions.headers['Authorization'] =
                  'Bearer $newToken';
              final retryResponse = await dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            } catch (_) {
              return handler.next(error);
            }
          }

          _isRefreshing = true;

          try {
            final refreshed = await _attemptTokenRefresh();
            if (refreshed) {
              // Read the new token
              final newToken =
                  await secureStorage.read(key: StorageKeys.accessToken);

              // Resolve all queued requests with the new token
              for (final completer in _pendingCompleters) {
                if (!completer.isCompleted) {
                  completer.complete(newToken ?? '');
                }
              }
              _pendingCompleters.clear();

              // Retry the original failed request
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newToken';
              final retryResponse = await dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            } else {
              // Refresh failed — reject all pending requests
              for (final completer in _pendingCompleters) {
                if (!completer.isCompleted) {
                  completer.completeError(error);
                }
              }
              _pendingCompleters.clear();
              await _clearTokensAndLogout();
              return handler.next(error);
            }
          } catch (e) {
            for (final completer in _pendingCompleters) {
              if (!completer.isCompleted) {
                completer.completeError(e);
              }
            }
            _pendingCompleters.clear();
            await _clearTokensAndLogout();
            return handler.next(error);
          } finally {
            _isRefreshing = false;
          }
        }
        return handler.next(error);
      },
    );
  }

  /// Attempt to refresh the access token using the stored refresh token.
  /// Returns true if refresh succeeded, false otherwise.
  Future<bool> _attemptTokenRefresh() async {
    final refreshToken =
        await secureStorage.read(key: StorageKeys.refreshToken);
    if (refreshToken == null) return false;

    try {
      // Use a separate Dio instance to avoid interceptor loops
      final refreshDio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final response = await refreshDio.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      final data = response.data;
      final newAccessToken =
          data['access_token'] ?? data['data']?['access_token'];
      final newRefreshToken =
          data['refresh_token'] ?? data['data']?['refresh_token'];

      if (newAccessToken != null) {
        await secureStorage.write(
            key: StorageKeys.accessToken, value: newAccessToken.toString());
        if (newRefreshToken != null) {
          await secureStorage.write(
              key: StorageKeys.refreshToken,
              value: newRefreshToken.toString());
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Clear stored tokens. The app should detect the missing token
  /// and navigate to the login screen on the next auth check.
  Future<void> _clearTokensAndLogout() async {
    await secureStorage.delete(key: StorageKeys.accessToken);
    await secureStorage.delete(key: StorageKeys.refreshToken);
  }
}
