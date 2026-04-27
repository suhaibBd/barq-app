import 'package:equatable/equatable.dart';

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
      ];
}
