import 'package:equatable/equatable.dart';
import '../../domain/entities/user_role.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserRole currentRole;
  final bool isDriverVerified;
  final String? documentStatus;
  final bool isOnline;

  const HomeLoaded({
    required this.currentRole,
    required this.isDriverVerified,
    this.documentStatus,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [currentRole, isDriverVerified, documentStatus, isOnline];

  HomeLoaded copyWith({
    UserRole? currentRole,
    bool? isDriverVerified,
    String? documentStatus,
    bool? isOnline,
  }) {
    return HomeLoaded(
      currentRole: currentRole ?? this.currentRole,
      isDriverVerified: isDriverVerified ?? this.isDriverVerified,
      documentStatus: documentStatus ?? this.documentStatus,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
