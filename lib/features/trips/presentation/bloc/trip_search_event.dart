import 'package:equatable/equatable.dart';

abstract class TripSearchEvent extends Equatable {
  const TripSearchEvent();
  @override
  List<Object?> get props => [];
}

class UpdateFromEvent extends TripSearchEvent {
  final String from;
  const UpdateFromEvent(this.from);
  @override
  List<Object?> get props => [from];
}

class UpdateToEvent extends TripSearchEvent {
  final String to;
  const UpdateToEvent(this.to);
  @override
  List<Object?> get props => [to];
}

class UpdateDateEvent extends TripSearchEvent {
  final DateTime date;
  const UpdateDateEvent(this.date);
  @override
  List<Object?> get props => [date];
}

class UpdateSeatsEvent extends TripSearchEvent {
  final int seats;
  const UpdateSeatsEvent(this.seats);
  @override
  List<Object?> get props => [seats];
}

class SearchTripsTriggeredEvent extends TripSearchEvent {}

class SwapLocationsEvent extends TripSearchEvent {}

enum TripSortOption { cheapest, earliest, topRated }

class ApplySortEvent extends TripSearchEvent {
  final TripSortOption sort;
  const ApplySortEvent(this.sort);
  @override
  List<Object?> get props => [sort];
}
