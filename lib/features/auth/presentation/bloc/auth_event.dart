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

class LogoutEvent extends AuthEvent {}
