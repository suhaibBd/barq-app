import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/location_tracking_service.dart';
import '../../../../di/injection_container.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/user_role.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthBloc authBloc;
  late final StreamSubscription _authSub;

  HomeBloc({required this.authBloc}) : super(HomeInitial()) {
    on<LoadHomeEvent>(_onLoadHome);
    on<SwitchRoleEvent>(_onSwitchRole);
    on<RefreshHomeEvent>(_onRefresh);
    on<ToggleOnlineEvent>(_onToggleOnline);

    _authSub = authBloc.stream.listen((authState) {
      if (authState is AuthAuthenticated) {
        add(RefreshHomeEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    return super.close();
  }

  UserRole _roleFromUser(User user) {
    return user.role == RegistrationRole.driver
        ? UserRole.driver
        : UserRole.restaurant;
  }

  Future<void> _onLoadHome(
    LoadHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    final authState = authBloc.state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      if (user.isOnline && user.role == RegistrationRole.driver) {
        sl<LocationTrackingService>().startTracking();
      }
      emit(HomeLoaded(
        currentRole: _roleFromUser(user),
        isDriverVerified: user.isDriverVerified,
        documentStatus: user.documentStatus,
        isOnline: user.isOnline,
      ));
    } else {
      emit(const HomeLoaded(
        currentRole: UserRole.restaurant,
        isDriverVerified: false,
      ));
    }
  }

  Future<void> _onSwitchRole(
    SwitchRoleEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(currentRole: event.role));
    }
    authBloc.add(RefreshProfileEvent());
  }

  Future<void> _onRefresh(
    RefreshHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    final authState = authBloc.state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      final currentState = state;
      final role = currentState is HomeLoaded
          ? currentState.currentRole
          : _roleFromUser(user);
      emit(HomeLoading());
      emit(HomeLoaded(
        currentRole: role,
        isDriverVerified: user.isDriverVerified,
        documentStatus: user.documentStatus,
        isOnline: user.isOnline,
      ));
    }
  }

  Future<void> _onToggleOnline(
    ToggleOnlineEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    try {
      final client = sl<DioClient>();
      await client.dio.patch(ApiConstants.toggleOnline);
      final newOnline = !currentState.isOnline;
      emit(currentState.copyWith(isOnline: newOnline));

      final locationService = sl<LocationTrackingService>();
      if (newOnline) {
        locationService.startTracking();
      } else {
        locationService.stopTracking();
      }

      authBloc.add(RefreshProfileEvent());
    } catch (_) {
      // Revert on failure — state unchanged
    }
  }
}
