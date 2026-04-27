import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/send_otp_usecase.dart';
import '../features/auth/domain/usecases/update_profile_usecase.dart';
import '../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ──
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Connectivity());

  // ── Core ──
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<Connectivity>()));
  sl.registerLazySingleton(
      () => DioClient(secureStorage: sl<FlutterSecureStorage>()));

  // ── Auth ──
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<DioClient>()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl<FlutterSecureStorage>(), sl<SharedPreferences>()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl<AuthRemoteDataSource>(),
        localDataSource: sl<AuthLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ));

  // Use cases
  sl.registerLazySingleton(() => SendOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(
        sendOtpUseCase: sl<SendOtpUseCase>(),
        verifyOtpUseCase: sl<VerifyOtpUseCase>(),
        getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
        updateProfileUseCase: sl<UpdateProfileUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
      ));

  sl.registerFactory(() => HomeBloc());

  // ── Trips ──
  // Note: TripRepository impl and data sources will be added later
  // For now, TripSearchBloc is registered but requires TripRepository
  // sl.registerFactory(() => TripSearchBloc(searchTripsUseCase: sl()));
}
