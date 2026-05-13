enum UserRole {
  restaurant,
  driver;

  String get arabicName => this == UserRole.restaurant ? 'مطعم' : 'سائق';
}
