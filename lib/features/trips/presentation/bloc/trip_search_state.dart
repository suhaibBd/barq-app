import 'package:equatable/equatable.dart';
import '../../domain/entities/trip.dart';

abstract class TripSearchState extends Equatable {
  const TripSearchState();
  @override
  List<Object?> get props => [];
}

class TripSearchInitial extends TripSearchState {}

class TripSearchCriteriaState extends TripSearchState {
  final String? from;
  final String? to;
  final DateTime? date;
  final int seats;

  const TripSearchCriteriaState({
    this.from,
    this.to,
    this.date,
    this.seats = 1,
  });

  @override
  List<Object?> get props => [from, to, date, seats];

  TripSearchCriteriaState copyWith({
    String? from,
    String? to,
    DateTime? date,
    int? seats,
  }) {
    return TripSearchCriteriaState(
      from: from ?? this.from,
      to: to ?? this.to,
      date: date ?? this.date,
      seats: seats ?? this.seats,
    );
  }
}

class TripSearchLoading extends TripSearchState {}

class TripSearchLoaded extends TripSearchState {
  final List<Trip> trips;
  final String from;
  final String to;
  final DateTime date;

  const TripSearchLoaded({
    required this.trips,
    required this.from,
    required this.to,
    required this.date,
  });

  @override
  List<Object?> get props => [trips, from, to, date];
}

class TripSearchEmpty extends TripSearchState {
  final String from;
  final String to;

  const TripSearchEmpty({required this.from, required this.to});

  @override
  List<Object?> get props => [from, to];
}

class TripSearchError extends TripSearchState {
  final String message;
  const TripSearchError(this.message);
  @override
  List<Object?> get props => [message];
}
