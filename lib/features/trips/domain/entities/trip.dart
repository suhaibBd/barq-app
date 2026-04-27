import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';
import 'location.dart';

class Trip extends Equatable {
  final String id;
  final User driver;
  final Location from;
  final Location to;
  final DateTime departureTime;
  final int availableSeats;
  final int totalSeats;
  final double pricePerSeat;
  final TripStatus status;
  final TripType type;
  final List<Location> waypoints;
  final PickupOptions pickupOptions;
  final TripRules rules;
  final DateTime createdAt;

  const Trip({
    required this.id,
    required this.driver,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.availableSeats,
    required this.totalSeats,
    required this.pricePerSeat,
    required this.status,
    required this.type,
    required this.waypoints,
    required this.pickupOptions,
    required this.rules,
    required this.createdAt,
  });

  bool get isFull => availableSeats == 0;
  bool get isPast => departureTime.isBefore(DateTime.now());

  @override
  List<Object?> get props => [
        id, driver, from, to, departureTime,
        availableSeats, totalSeats, pricePerSeat,
        status, type, waypoints, pickupOptions, rules, createdAt,
      ];
}

enum TripStatus { draft, active, completed, cancelled }

enum TripType { interCity, intraCity }

class PickupOptions extends Equatable {
  final bool doorToDoor;
  final bool meetingPoint;
  final String? meetingPointDescription;

  const PickupOptions({
    required this.doorToDoor,
    required this.meetingPoint,
    this.meetingPointDescription,
  });

  @override
  List<Object?> get props =>
      [doorToDoor, meetingPoint, meetingPointDescription];
}

class TripRules extends Equatable {
  final bool smokingAllowed;
  final bool petsAllowed;
  final bool musicAllowed;
  final bool luggageAllowed;
  final bool femaleOnly;

  const TripRules({
    required this.smokingAllowed,
    required this.petsAllowed,
    required this.musicAllowed,
    required this.luggageAllowed,
    required this.femaleOnly,
  });

  @override
  List<Object?> get props =>
      [smokingAllowed, petsAllowed, musicAllowed, luggageAllowed, femaleOnly];
}
