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
    super.role,
    super.nationalIdUrl,
    super.driverLicenseUrl,
    super.carImageUrl,
    super.carNumber,
    super.documentStatus,
    super.isOnline,
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
      role: json['role'] == 'driver'
          ? RegistrationRole.driver
          : RegistrationRole.restaurant,
      nationalIdUrl: json['national_id_url'] as String?,
      driverLicenseUrl: json['driver_license_url'] as String?,
      carImageUrl: json['car_image_url'] as String?,
      carNumber: json['car_number'] as String?,
      documentStatus: json['document_status'] as String?,
      isOnline: json['is_online'] as bool? ?? false,
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
        'role': role == RegistrationRole.driver ? 'driver' : 'restaurant',
        'national_id_url': nationalIdUrl,
        'driver_license_url': driverLicenseUrl,
        'car_image_url': carImageUrl,
        'car_number': carNumber,
        'is_online': isOnline,
      };
}
