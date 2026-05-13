import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthOtpSent extends AuthState {
  final String verificationId;
  final String phone;
  final String? devCode;
  const AuthOtpSent({required this.verificationId, required this.phone, this.devCode});
  @override
  List<Object?> get props => [verificationId, phone, devCode];
}

class AuthAuthenticated extends AuthState {
  final User user;
  final bool isNewUser;
  const AuthAuthenticated({required this.user, this.isNewUser = false});
  @override
  List<Object?> get props => [user, isNewUser];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
