import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../features/shipments/presentation/widgets/shipment_assignment_dialog.dart';
import '../../main.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    }
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    if (data['type'] == 'shipment_assignment') {
      _showAssignmentDialog(data);
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    final data = message.data;
    if (data['type'] == 'shipment_assignment') {
      _showAssignmentDialog(data);
    }
  }

  void _showAssignmentDialog(Map<String, dynamic> data) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    final shipmentId = int.tryParse(data['shipment_id']?.toString() ?? '');
    if (shipmentId == null) return;

    final expiresAt =
        DateTime.tryParse(data['expires_at']?.toString() ?? '') ??
            DateTime.now().add(const Duration(minutes: 2));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ShipmentAssignmentDialog(
        shipmentId: shipmentId,
        fromCity: data['from_city']?.toString() ?? '',
        toCity: data['to_city']?.toString() ?? '',
        price: data['price']?.toString() ?? '0',
        description: data['description']?.toString() ?? '',
        expiresAt: expiresAt,
      ),
    );
  }
}
