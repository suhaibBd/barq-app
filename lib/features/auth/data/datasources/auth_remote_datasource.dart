import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> sendOtp(String phone);
  Future<AuthResponseModel> verifyOtp({
    required String verificationId,
    required String code,
  });
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateProfile(Map<String, dynamic> data);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<String> sendOtp(String phone) async {
    try {
      final response = await client.dio.post(
        ApiConstants.sendOtp,
        data: {'phone': phone},
      );
      return response.data['verification_id'] as String;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل إرسال الرمز');
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String verificationId,
    required String code,
  }) async {
    try {
      final response = await client.dio.post(
        ApiConstants.verifyOtp,
        data: {
          'verification_id': verificationId,
          'code': code,
        },
      );
      return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل التحقق من الرمز');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await client.dio.get(ApiConstants.profile);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل تحميل البيانات');
    }
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await client.dio.patch(
        ApiConstants.updateProfile,
        data: data,
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل تحديث البيانات');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await client.dio.post(ApiConstants.logout);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل تسجيل الخروج');
    }
  }
}
