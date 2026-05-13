import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ({String verificationId, String? devCode})>> sendOtp(String phone) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await remoteDataSource.sendOtp(phone);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String verificationId,
    required String code,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response = await remoteDataSource.verifyOtp(
        verificationId: verificationId,
        code: code,
      );
      await localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await localDataSource.saveUser(response.user);
      return Right(response.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final token = await localDataSource.getAccessToken();
      if (token == null) return const Right(null);

      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) return Right(cachedUser);

      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.saveUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> refreshProfile() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.saveUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.logout();
      }
      await localDataSource.clearTokens();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> verifyFirebaseToken(
      String firebaseIdToken) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response =
          await remoteDataSource.verifyFirebaseToken(firebaseIdToken);
      await localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await localDataSource.saveUser(response.user);
      return Right(response.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<void> registerFcmToken(String fcmToken) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.registerFcmToken(fcmToken);
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
    RegistrationRole role = RegistrationRole.restaurant,
    String? nationalIdPath,
    String? driverLicensePath,
    String? carImagePath,
    String? carNumber,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final data = <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'role': role == RegistrationRole.driver ? 'driver' : 'passenger',
        if (email != null) 'email': email,
        if (carNumber != null) 'car_number': carNumber,
      };
      var user = await remoteDataSource.updateProfile(data);

      if (role == RegistrationRole.driver &&
          nationalIdPath != null &&
          driverLicensePath != null &&
          carImagePath != null &&
          carNumber != null) {
        await remoteDataSource.submitDriverDocuments(
          nationalIdPath: nationalIdPath,
          driverLicensePath: driverLicensePath,
          carImagePath: carImagePath,
          carNumber: carNumber,
        );
        user = await remoteDataSource.getCurrentUser();
      }

      await localDataSource.saveUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
