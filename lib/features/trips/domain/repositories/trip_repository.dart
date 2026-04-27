import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trip.dart';

abstract class TripRepository {
  Future<Either<Failure, List<Trip>>> searchTrips({
    required String from,
    required String to,
    required DateTime date,
    int? seats,
  });

  Future<Either<Failure, Trip>> getTripDetails(String tripId);

  Future<Either<Failure, Trip>> createTrip(Trip trip);

  Future<Either<Failure, Trip>> updateTrip(Trip trip);

  Future<Either<Failure, void>> cancelTrip(String tripId);

  Future<Either<Failure, List<Trip>>> getMyTrips();
}
