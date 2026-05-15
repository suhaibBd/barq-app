import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, ({String verificationId, String? devCode})>> sendOtp(String phone);

  Future<Either<Failure, User>> verifyOtp({
    required String verificationId,
    required String code,
  });

  Future<Either<Failure, User>> verifyFirebaseToken(String firebaseIdToken);

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, User>> refreshProfile();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
    RegistrationRole role = RegistrationRole.store,
    String? nationalIdPath,
    String? driverLicensePath,
    String? carImagePath,
    String? carNumber,
  });

  Future<void> registerFcmToken(String fcmToken);
}
