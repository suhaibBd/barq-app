import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.phone,
    super.email,
    required super.firstName,
    required super.lastName,
    super.avatarUrl,
    required super.isDriverVerified,
    required super.rating,
    required super.totalTrips,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      isDriverVerified: json['is_driver_verified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      totalTrips: json['total_trips'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'avatar_url': avatarUrl,
        'is_driver_verified': isDriverVerified,
        'rating': rating,
        'total_trips': totalTrips,
        'created_at': createdAt.toIso8601String(),
      };
}
