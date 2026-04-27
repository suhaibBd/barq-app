import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_role.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeEvent>(_onLoadHome);
    on<SwitchRoleEvent>(_onSwitchRole);
    on<RefreshHomeEvent>(_onRefresh);
  }

  Future<void> _onLoadHome(
    LoadHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    // Load persisted role preference
    emit(const HomeLoaded(
      currentRole: UserRole.passenger,
      isDriverVerified: false,
    ));
  }

  Future<void> _onSwitchRole(
    SwitchRoleEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(currentRole: event.role));
    }
  }

  Future<void> _onRefresh(
    RefreshHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(HomeLoading());
      emit(HomeLoaded(
        currentRole: currentState.currentRole,
        isDriverVerified: currentState.isDriverVerified,
      ));
    }
  }
}
