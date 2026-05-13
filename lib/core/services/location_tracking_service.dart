import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../constants/api_constants.dart';
import '../network/dio_client.dart';

class LocationTrackingService {
  final DioClient _dioClient;
  Timer? _timer;
  bool _isTracking = false;

  LocationTrackingService(this._dioClient);

  bool get isTracking => _isTracking;

  Future<void> startTracking() async {
    if (_isTracking) return;

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied ||
          requested == LocationPermission.deniedForever) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) return;

    _isTracking = true;
    await _sendLocation();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _sendLocation());
  }

  void stopTracking() {
    _timer?.cancel();
    _timer = null;
    _isTracking = false;
  }

  Future<void> _sendLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );
      await _dioClient.dio.post(ApiConstants.updateDriverLocation, data: {
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } catch (_) {}
  }
}
