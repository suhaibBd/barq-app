import 'dart:io' show Platform;

class ApiConstants {
  // For production builds, pass the URL at build time:
  //   flutter build apk --dart-define=API_BASE_URL=https://api.barq-app.com/api/v1
  //   flutter build ios --dart-define=API_BASE_URL=https://api.barq-app.com/api/v1
  static const bool _isProduction = bool.fromEnvironment('dart.vm.product');
  static const String _customUrl = String.fromEnvironment('API_BASE_URL');

  static final String baseUrl = _customUrl.isNotEmpty
      ? _customUrl
      : _isProduction
          ? 'https://api.barq-app.com/api/v1'
          : Platform.isAndroid
              ? 'http://10.0.2.2:8000/api/v1'
              : 'http://localhost:8000/api/v1';

  // Auth
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String verifyFirebaseToken = '/auth/firebase-verify';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String registerFcmToken = '/auth/fcm-token';

  // Profile
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String uploadAvatar = '/profile/avatar';
  static const String toggleOnline = '/profile/toggle-online';

  // Wallet
  static const String wallet = '/wallet';
  static const String transactions = '/wallet/transactions';
  static const String topup = '/wallet/topup';
  static const String rechargeCard = '/wallet/recharge';

  // Ratings
  static const String rateUser = '/ratings';
  static const String myRatings = '/ratings/my';

  // Notifications
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications';

  // Messaging
  static const String conversations = '/conversations';
  static const String messages = '/messages';

  // Driver Location
  static const String updateDriverLocation = '/driver/location';

  // Orders (Shipments)
  static const String createShipment = '/shipments';
  static const String myShipments = '/shipments/my';
  static const String availableShipments = '/shipments/available';
  static const String shipmentPriceEstimate = '/shipments/price-estimate';
  static String shipmentById(int id) => '/shipments/$id';
  static String acceptShipment(int id) => '/shipments/$id/accept';
  static String rejectShipment(int id) => '/shipments/$id/reject';
}
