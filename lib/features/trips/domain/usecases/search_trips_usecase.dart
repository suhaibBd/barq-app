import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trip.dart';
import '../repositories/trip_repository.dart';

class SearchTripsUseCase implements UseCase<List<Trip>, SearchTripsParams> {
  final TripRepository repository;

  SearchTripsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Trip>>> call(SearchTripsParams params) async {
    return await repository.searchTrips(
      from: params.from,
      to: params.to,
      date: params.date,
      seats: params.seats,
    );
  }
}

class SearchTripsParams extends Equatable {
  final String from;
  final String to;
  final DateTime date;
  final int? seats;

  const SearchTripsParams({
    required this.from,
    required this.to,
    required this.date,
    this.seats,
  });

  @override
  List<Object?> get props => [from, to, date, seats];
}
