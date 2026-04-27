import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> sendOtp(String phone);

  Future<Either<Failure, User>> verifyOtp({
    required String verificationId,
    required String code,
  });

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
  });
}
