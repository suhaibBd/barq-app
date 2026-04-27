class ApiConstants {
  static const String baseUrl = 'https://api.rafiq.jo/v1';

  // Auth
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Profile
  static const String profile = '/profile';
  static const String updateProfile = '/profile';
  static const String uploadAvatar = '/profile/avatar';

  // Trips
  static const String searchTrips = '/trips/search';
  static const String tripDetails = '/trips';
  static const String createTrip = '/trips';
  static const String myTrips = '/trips/my';

  // Bookings
  static const String createBooking = '/bookings';
  static const String myBookings = '/bookings/my';
  static const String bookingRequests = '/bookings/requests';

  // Wallet
  static const String wallet = '/wallet';
  static const String transactions = '/wallet/transactions';
  static const String topup = '/wallet/topup';

  // Messaging
  static const String conversations = '/conversations';
  static const String messages = '/messages';
}
