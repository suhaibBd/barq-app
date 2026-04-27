import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<String?> getAccessToken();
  Future<void> clearTokens();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl(this.secureStorage, this.prefs);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await secureStorage.write(
        key: StorageKeys.accessToken, value: accessToken);
    await secureStorage.write(
        key: StorageKeys.refreshToken, value: refreshToken);
  }

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: StorageKeys.accessToken);
  }

  @override
  Future<void> clearTokens() async {
    await secureStorage.delete(key: StorageKeys.accessToken);
    await secureStorage.delete(key: StorageKeys.refreshToken);
    await prefs.remove(StorageKeys.cachedUser);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await prefs.setString(
        StorageKeys.cachedUser, json.encode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonStr = prefs.getString(StorageKeys.cachedUser);
    if (jsonStr == null) return null;
    try {
      return UserModel.fromJson(json.decode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      throw CacheException('فشل قراءة بيانات المستخدم');
    }
  }
}
