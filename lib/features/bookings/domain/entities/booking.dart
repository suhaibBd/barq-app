import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../trips/domain/entities/trip.dart';
import '../../../trips/domain/entities/location.dart';

class Booking extends Equatable {
  final String id;
  final Trip trip;
  final User passenger;
  final int seatsCount;
  final List<PassengerInfo> passengers;
  final Location? pickupLocation;
  final BookingStatus status;
  final double totalPrice;
  final DateTime createdAt;
  final String? notes;

  const Booking({
    required this.id,
    required this.trip,
    required this.passenger,
    required this.seatsCount,
    required this.passengers,
    this.pickupLocation,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id, trip, passenger, seatsCount, passengers,
        pickupLocation, status, totalPrice, createdAt, notes,
      ];
}

class PassengerInfo extends Equatable {
  final String name;
  final String? phone;

  const PassengerInfo({required this.name, this.phone});

  @override
  List<Object?> get props => [name, phone];
}

enum BookingStatus {
  pendingDriverConfirmation,
  confirmed,
  inProgress,
  completed,
  cancelled,
  rejected;

  String get arabicName {
    switch (this) {
      case BookingStatus.pendingDriverConfirmation:
        return 'بانتظار تأكيد السائق';
      case BookingStatus.confirmed:
        return 'مؤكد';
      case BookingStatus.inProgress:
        return 'جارية';
      case BookingStatus.completed:
        return 'مكتملة';
      case BookingStatus.cancelled:
        return 'ملغاة';
      case BookingStatus.rejected:
        return 'مرفوضة';
    }
  }
}
