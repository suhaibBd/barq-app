enum UserRole {
  passenger,
  driver;

  String get arabicName => this == UserRole.passenger ? 'راكب' : 'سائق';
  String get icon => this == UserRole.passenger ? '🧑' : '🚗';
}
