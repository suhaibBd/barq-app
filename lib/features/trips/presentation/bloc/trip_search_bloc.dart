import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/search_trips_usecase.dart';
import 'trip_search_event.dart';
import 'trip_search_state.dart';

class TripSearchBloc extends Bloc<TripSearchEvent, TripSearchState> {
  final SearchTripsUseCase searchTripsUseCase;

  TripSearchBloc({required this.searchTripsUseCase})
      : super(const TripSearchCriteriaState()) {
    on<UpdateFromEvent>(_onUpdateFrom);
    on<UpdateToEvent>(_onUpdateTo);
    on<UpdateDateEvent>(_onUpdateDate);
    on<UpdateSeatsEvent>(_onUpdateSeats);
    on<SwapLocationsEvent>(_onSwapLocations);
    on<SearchTripsTriggeredEvent>(_onSearch);
    on<ApplySortEvent>(_onApplySort);
  }

  void _onUpdateFrom(UpdateFromEvent event, Emitter<TripSearchState> emit) {
    final current = _currentCriteria;
    emit(current.copyWith(from: event.from));
  }

  void _onUpdateTo(UpdateToEvent event, Emitter<TripSearchState> emit) {
    final current = _currentCriteria;
    emit(current.copyWith(to: event.to));
  }

  void _onUpdateDate(UpdateDateEvent event, Emitter<TripSearchState> emit) {
    final current = _currentCriteria;
    emit(current.copyWith(date: event.date));
  }

  void _onUpdateSeats(UpdateSeatsEvent event, Emitter<TripSearchState> emit) {
    final current = _currentCriteria;
    emit(current.copyWith(seats: event.seats));
  }

  void _onSwapLocations(
      SwapLocationsEvent event, Emitter<TripSearchState> emit) {
    final current = _currentCriteria;
    emit(TripSearchCriteriaState(
      from: current.to,
      to: current.from,
      date: current.date,
      seats: current.seats,
    ));
  }

  Future<void> _onSearch(
    SearchTripsTriggeredEvent event,
    Emitter<TripSearchState> emit,
  ) async {
    final criteria = _currentCriteria;
    if (criteria.from == null || criteria.to == null || criteria.date == null) {
      return;
    }

    emit(TripSearchLoading());
    final result = await searchTripsUseCase(SearchTripsParams(
      from: criteria.from!,
      to: criteria.to!,
      date: criteria.date!,
      seats: criteria.seats,
    ));

    result.fold(
      (failure) => emit(TripSearchError(failure.message)),
      (trips) {
        if (trips.isEmpty) {
          emit(TripSearchEmpty(from: criteria.from!, to: criteria.to!));
        } else {
          emit(TripSearchLoaded(
            trips: trips,
            from: criteria.from!,
            to: criteria.to!,
            date: criteria.date!,
          ));
        }
      },
    );
  }

  void _onApplySort(ApplySortEvent event, Emitter<TripSearchState> emit) {
    final currentState = state;
    if (currentState is TripSearchLoaded) {
      final sorted = List.of(currentState.trips);
      switch (event.sort) {
        case TripSortOption.cheapest:
          sorted.sort((a, b) => a.pricePerSeat.compareTo(b.pricePerSeat));
        case TripSortOption.earliest:
          sorted.sort((a, b) => a.departureTime.compareTo(b.departureTime));
        case TripSortOption.topRated:
          sorted.sort((a, b) => b.driver.rating.compareTo(a.driver.rating));
      }
      emit(TripSearchLoaded(
        trips: sorted,
        from: currentState.from,
        to: currentState.to,
        date: currentState.date,
      ));
    }
  }

  TripSearchCriteriaState get _currentCriteria {
    final s = state;
    if (s is TripSearchCriteriaState) return s;
    return const TripSearchCriteriaState();
  }
}
