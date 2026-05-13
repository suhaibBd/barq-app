import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/locale/locale_notifier.dart';
import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';
import '../core/services/firebase_auth_service.dart';
import '../core/services/location_tracking_service.dart';
import '../core/services/notification_service.dart';
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

  // ── Locale ──
  sl.registerLazySingleton(() => LocaleNotifier(sl<SharedPreferences>()));

  // ── Core ──
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<Connectivity>()));
  sl.registerLazySingleton(
      () => DioClient(secureStorage: sl<FlutterSecureStorage>()));

  // ── Firebase Services ──
  sl.registerLazySingleton(() => FirebaseAuthService());
  sl.registerLazySingleton(() => NotificationService());
  sl.registerLazySingleton(() => LocationTrackingService(sl<DioClient>()));

  // ── Auth ──
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<DioClient>()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl<FlutterSecureStorage>(), sl<SharedPreferences>()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl<AuthRemoteDataSource>(),
        localDataSource: sl<AuthLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ));

  sl.registerLazySingleton(() => SendOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton(() => AuthBloc(
        sendOtpUseCase: sl<SendOtpUseCase>(),
        verifyOtpUseCase: sl<VerifyOtpUseCase>(),
        getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
        updateProfileUseCase: sl<UpdateProfileUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
        firebaseAuthService: sl<FirebaseAuthService>(),
        authRepository: sl<AuthRepository>(),
      ));

  sl.registerFactory(() => HomeBloc(authBloc: sl<AuthBloc>()));
}
