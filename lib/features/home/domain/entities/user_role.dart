enum UserRole {
  store,
  driver;

  String get arabicName => this == UserRole.store ? 'متجر' : 'سائق';
}
