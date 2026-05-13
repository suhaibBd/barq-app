import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripMapView extends StatelessWidget {
  final double fromLat;
  final double fromLng;
  final double toLat;
  final double toLng;
  final double height;

  const TripMapView({
    super.key,
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final from = LatLng(fromLat, fromLng);
    final to = LatLng(toLat, toLng);
    final midLat = (fromLat + toLat) / 2;
    final midLng = (fromLng + toLng) / 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(midLat, midLng),
            zoom: 8,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('from'),
              position: from,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              infoWindow: const InfoWindow(title: 'نقطة الانطلاق'),
            ),
            Marker(
              markerId: const MarkerId('to'),
              position: to,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              infoWindow: const InfoWindow(title: 'نقطة الوصول'),
            ),
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId('route'),
              points: [from, to],
              color: const Color(0xFF0F4C3A),
              width: 3,
            ),
          },
          zoomControlsEnabled: false,
          scrollGesturesEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          myLocationButtonEnabled: false,
          liteModeEnabled: true,
        ),
      ),
    );
  }
}
