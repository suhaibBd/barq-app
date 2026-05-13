import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class SendOtpEvent extends AuthEvent {
  final String phone;
  const SendOtpEvent(this.phone);
  @override
  List<Object?> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String verificationId;
  final String code;
  const VerifyOtpEvent({required this.verificationId, required this.code});
  @override
  List<Object?> get props => [verificationId, code];
}

class UpdateProfileEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String? email;
  const UpdateProfileEvent({
    required this.firstName,
    required this.lastName,
    this.email,
  });
  @override
  List<Object?> get props => [firstName, lastName, email];
}

class RegisterDriverEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String? email;
  final String nationalIdPath;
  final String driverLicensePath;
  final String carImagePath;
  final String carNumber;
  const RegisterDriverEvent({
    required this.firstName,
    required this.lastName,
    this.email,
    required this.nationalIdPath,
    required this.driverLicensePath,
    required this.carImagePath,
    required this.carNumber,
  });
  @override
  List<Object?> get props => [
        firstName, lastName, email,
        nationalIdPath, driverLicensePath, carImagePath, carNumber,
      ];
}

class FirebasePhoneVerifyEvent extends AuthEvent {
  final String phone;
  const FirebasePhoneVerifyEvent(this.phone);
  @override
  List<Object?> get props => [phone];
}

class FirebaseOtpSentEvent extends AuthEvent {
  final String verificationId;
  final String phone;
  final int? resendToken;
  const FirebaseOtpSentEvent({
    required this.verificationId,
    required this.phone,
    this.resendToken,
  });
  @override
  List<Object?> get props => [verificationId, phone, resendToken];
}

class FirebaseOtpVerifyEvent extends AuthEvent {
  final String verificationId;
  final String smsCode;
  const FirebaseOtpVerifyEvent({
    required this.verificationId,
    required this.smsCode,
  });
  @override
  List<Object?> get props => [verificationId, smsCode];
}

class FirebaseAutoVerifiedEvent extends AuthEvent {
  final String firebaseIdToken;
  const FirebaseAutoVerifiedEvent(this.firebaseIdToken);
  @override
  List<Object?> get props => [firebaseIdToken];
}

class RefreshProfileEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class DevLoginEvent extends AuthEvent {
  final bool asDriver;
  const DevLoginEvent({this.asDriver = true});
  @override
  List<Object?> get props => [asDriver];
}

class AuthErrorDelegateEvent extends AuthEvent {
  final String message;
  const AuthErrorDelegateEvent(this.message);
  @override
  List<Object?> get props => [message];
}
