import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

typedef OtpResult = ({String verificationId, String? devCode});

abstract class AuthRemoteDataSource {
  Future<OtpResult> sendOtp(String phone);
  Future<AuthResponseModel> verifyOtp({
    required String verificationId,
    required String code,
  });
  Future<AuthResponseModel> verifyFirebaseToken(String firebaseIdToken);
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateProfile(Map<String, dynamic> data);
  Future<void> submitDriverDocuments({
    required String nationalIdPath,
    required String driverLicensePath,
    required String carImagePath,
    required String carNumber,
  });
  Future<void> logout();
  Future<void> registerFcmToken(String fcmToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<OtpResult> sendOtp(String phone) async {
    try {
      final response = await client.dio.post(
        ApiConstants.sendOtp,
        data: {'phone': phone},
      );
      return (
        verificationId: response.data['verification_id'] as String,
        devCode: response.data['dev_code'] as String?,
      );
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
      final response = await client.dio.post(
        ApiConstants.updateProfile,
        data: data,
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل تحديث البيانات');
    }
  }

  @override
  Future<AuthResponseModel> verifyFirebaseToken(String firebaseIdToken) async {
    try {
      final response = await client.dio.post(
        ApiConstants.verifyFirebaseToken,
        data: {'firebase_token': firebaseIdToken},
      );
      return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل التحقق من Firebase');
    }
  }

  @override
  Future<void> submitDriverDocuments({
    required String nationalIdPath,
    required String driverLicensePath,
    required String carImagePath,
    required String carNumber,
  }) async {
    try {
      final formData = FormData.fromMap({
        'national_id': await MultipartFile.fromFile(nationalIdPath),
        'driver_license': await MultipartFile.fromFile(driverLicensePath),
        'car_image': await MultipartFile.fromFile(carImagePath),
        'car_number': carNumber,
      });
      await client.dio.post('/driver/documents', data: formData);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل رفع الوثائق');
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

  @override
  Future<void> registerFcmToken(String fcmToken) async {
    try {
      await client.dio.post(ApiConstants.registerFcmToken, data: {
        'fcm_token': fcmToken,
      });
    } on DioException catch (_) {
      // Non-critical, silently fail
    }
  }
}
