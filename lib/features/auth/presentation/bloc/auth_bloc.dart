import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final LogoutUseCase logoutUseCase;
  final FirebaseAuthService firebaseAuthService;
  final AuthRepository authRepository;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.getCurrentUserUseCase,
    required this.updateProfileUseCase,
    required this.logoutUseCase,
    required this.firebaseAuthService,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<FirebasePhoneVerifyEvent>(_onFirebasePhoneVerify);
    on<FirebaseOtpSentEvent>(_onFirebaseOtpSent);
    on<FirebaseOtpVerifyEvent>(_onFirebaseOtpVerify);
    on<FirebaseAutoVerifiedEvent>(_onFirebaseAutoVerified);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<RegisterDriverEvent>(_onRegisterDriver);
    on<RefreshProfileEvent>(_onRefreshProfile);
    on<LogoutEvent>(_onLogout);
    on<DevLoginEvent>(_onDevLogin);
    on<AuthErrorDelegateEvent>((event, emit) => emit(AuthError(event.message)));
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getCurrentUserUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await sendOtpUseCase(SendOtpParams(phone: event.phone));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (otpResult) => emit(AuthOtpSent(
        verificationId: otpResult.verificationId,
        phone: event.phone,
        devCode: otpResult.devCode,
      )),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyOtpUseCase(VerifyOtpParams(
      verificationId: event.verificationId,
      code: event.code,
    ));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(
        user: user,
        isNewUser: user.firstName.isEmpty,
      )),
    );
  }

  Future<void> _onFirebasePhoneVerify(
    FirebasePhoneVerifyEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await firebaseAuthService.verifyPhone(
        phoneNumber: event.phone,
        onCodeSent: (verificationId, resendToken) {
          add(FirebaseOtpSentEvent(
            verificationId: verificationId,
            phone: event.phone,
            resendToken: resendToken,
          ));
        },
        onAutoVerified: (credential) async {
          final userCred =
              await firebaseAuthService.signInWithCredential(credential);
          final idToken = await userCred.user?.getIdToken();
          if (idToken != null) {
            add(FirebaseAutoVerifiedEvent(idToken));
          }
        },
        onError: (error) {
          add(AuthErrorDelegateEvent(error));
        },
      );
    } catch (e) {
      print('Firebase verifyPhone exception: $e');
      emit(AuthError('فشل إرسال رمز التحقق: $e'));
    }
  }

  void _onFirebaseOtpSent(
    FirebaseOtpSentEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthOtpSent(
      verificationId: event.verificationId,
      phone: event.phone,
    ));
  }

  Future<void> _onFirebaseOtpVerify(
    FirebaseOtpVerifyEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCred = await firebaseAuthService.verifyOtp(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
      );
      final idToken = await userCred.user?.getIdToken();
      if (idToken == null) {
        emit(AuthError('فشل التحقق'));
        return;
      }
      final result = await authRepository.verifyFirebaseToken(idToken);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthAuthenticated(
          user: user,
          isNewUser: user.firstName.isEmpty,
        )),
      );
    } catch (_) {
      emit(AuthError('رمز التحقق غير صحيح'));
    }
  }

  Future<void> _onFirebaseAutoVerified(
    FirebaseAutoVerifiedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.verifyFirebaseToken(event.firebaseIdToken);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(
        user: user,
        isNewUser: user.firstName.isEmpty,
      )),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await updateProfileUseCase(UpdateProfileParams(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
    ));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onRegisterDriver(
    RegisterDriverEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await updateProfileUseCase(UpdateProfileParams(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      role: RegistrationRole.driver,
      nationalIdPath: event.nationalIdPath,
      driverLicensePath: event.driverLicensePath,
      carImagePath: event.carImagePath,
      carNumber: event.carNumber,
    ));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await authRepository.refreshProfile();
    result.fold(
      (failure) {},
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  void _onDevLogin(DevLoginEvent event, Emitter<AuthState> emit) {
    final dummyUser = event.asDriver
        ? User(
            id: 'dev-driver-001',
            phone: '+962790000000',
            email: 'driver@barq.test',
            firstName: 'سائق',
            lastName: 'تجريبي',
            isDriverVerified: true,
            rating: 4.8,
            totalTrips: 12,
            createdAt: DateTime(2025, 1, 1),
          )
        : User(
            id: 'dev-store-001',
            phone: '+962780000000',
            email: 'store@barq.test',
            firstName: 'متجر',
            lastName: 'تجريبي',
            isDriverVerified: false,
            rating: 5.0,
            totalTrips: 0,
            createdAt: DateTime(2025, 1, 1),
          );
    emit(AuthAuthenticated(user: dummyUser));
  }
}
