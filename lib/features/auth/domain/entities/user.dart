import 'package:equatable/equatable.dart';

enum RegistrationRole {
  restaurant,
  driver;

  String get arabicName => this == RegistrationRole.restaurant ? 'مطعم' : 'سائق';
}

class User extends Equatable {
  final String id;
  final String phone;
  final String? email;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final bool isDriverVerified;
  final double rating;
  final int totalTrips;
  final DateTime createdAt;
  final RegistrationRole role;
  final String? nationalIdUrl;
  final String? driverLicenseUrl;
  final String? carImageUrl;
  final String? carNumber;
  final String? documentStatus;
  final bool isOnline;

  const User({
    required this.id,
    required this.phone,
    this.email,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    required this.isDriverVerified,
    required this.rating,
    required this.totalTrips,
    required this.createdAt,
    this.role = RegistrationRole.restaurant,
    this.nationalIdUrl,
    this.driverLicenseUrl,
    this.carImageUrl,
    this.carNumber,
    this.documentStatus,
    this.isOnline = false,
  });

  String get fullName => '$firstName $lastName';
  String get initials =>
      firstName.isNotEmpty && lastName.isNotEmpty
          ? '${firstName[0]}${lastName[0]}'
          : '';

  @override
  List<Object?> get props => [
        id, phone, email, firstName, lastName,
        avatarUrl, isDriverVerified, rating, totalTrips, createdAt,
        role, nationalIdUrl, driverLicenseUrl, carImageUrl, carNumber,
        documentStatus, isOnline,
      ];
}
