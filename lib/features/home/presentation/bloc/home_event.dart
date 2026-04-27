import 'package:equatable/equatable.dart';
import '../../domain/entities/user_role.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class LoadHomeEvent extends HomeEvent {}

class SwitchRoleEvent extends HomeEvent {
  final UserRole role;
  const SwitchRoleEvent(this.role);
  @override
  List<Object?> get props => [role];
}

class RefreshHomeEvent extends HomeEvent {}
