import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String name;
  final String? city;
  final double latitude;
  final double longitude;

  const Location({
    required this.id,
    required this.name,
    this.city,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [id, name, city, latitude, longitude];
}
