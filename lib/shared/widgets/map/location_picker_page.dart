import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';

const _kGoogleApiKey = 'AIzaSyDqtM8IjHY51ytZZkbOJ6v1ixhuhxtjc8s';

class PickedLocation {
  final double lat;
  final double lng;
  final String cityName;
  final String address;

  const PickedLocation({
    required this.lat,
    required this.lng,
    required this.cityName,
    required this.address,
  });
}

class _PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  const _PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });
}

class LocationPickerPage extends StatefulWidget {
  final String title;
  final LatLng? initialLocation;

  const LocationPickerPage({
    super.key,
    required this.title,
    this.initialLocation,
  });

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  GoogleMapController? _mapController;
  final _selectedLocation =
      ValueNotifier<LatLng>(const LatLng(31.9539, 35.9106));
  final _address = ValueNotifier<String>('');
  final _cityName = ValueNotifier<String>('');
  final _loading = ValueNotifier<bool>(false);

  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _predictions = ValueNotifier<List<_PlacePrediction>>([]);
  final _showSearch = ValueNotifier<bool>(false);
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation.value = widget.initialLocation!;
      _reverseGeocode(_selectedLocation.value);
    } else {
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _selectedLocation.dispose();
    _address.dispose();
    _cityName.dispose();
    _loading.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _predictions.dispose();
    _showSearch.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _reverseGeocode(_selectedLocation.value);
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _selectedLocation.value = LatLng(position.latitude, position.longitude);
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_selectedLocation.value),
      );
      _reverseGeocode(_selectedLocation.value);
    } catch (_) {
      _reverseGeocode(_selectedLocation.value);
    }
  }

  Future<void> _reverseGeocode(LatLng position) async {
    _loading.value = true;
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        _cityName.value = p.locality ??
            p.subAdministrativeArea ??
            p.administrativeArea ??
            '';
        _address.value = [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
        ].where((s) => s != null && s.isNotEmpty).join('، ');
      }
    } catch (_) {
      _cityName.value = '';
      _address.value =
          '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
    }
    _loading.value = false;
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      _predictions.value = [];
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchPredictions(query.trim());
    });
  }

  Future<void> _fetchPredictions(String query) async {
    final loc = _selectedLocation.value;
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=${Uri.encodeComponent(query)}'
      '&key=$_kGoogleApiKey'
      '&language=ar'
      '&components=country:jo'
      '&location=${loc.latitude},${loc.longitude}'
      '&radius=200000',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = (data['predictions'] as List?) ?? [];
        _predictions.value = results.map((p) {
          final structured = p['structured_formatting'] ?? {};
          return _PlacePrediction(
            placeId: p['place_id'] as String,
            description: p['description'] as String? ?? '',
            mainText: structured['main_text'] as String? ?? '',
            secondaryText: structured['secondary_text'] as String? ?? '',
          );
        }).toList();
      }
    } catch (_) {}
  }

  Future<void> _selectPrediction(_PlacePrediction prediction) async {
    _predictions.value = [];
    _searchController.clear();
    _searchFocusNode.unfocus();
    _showSearch.value = false;
    _loading.value = true;

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=${prediction.placeId}'
        '&key=$_kGoogleApiKey'
        '&fields=geometry,formatted_address,address_components',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];
        if (result != null) {
          final geometry = result['geometry']?['location'];
          if (geometry != null) {
            final lat = (geometry['lat'] as num).toDouble();
            final lng = (geometry['lng'] as num).toDouble();
            final latLng = LatLng(lat, lng);

            _selectedLocation.value = latLng;
            _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: latLng, zoom: 15),
              ),
            );

            // Extract city from address_components
            final components = result['address_components'] as List? ?? [];
            String city = '';
            for (final c in components) {
              final types = (c['types'] as List?)?.cast<String>() ?? [];
              if (types.contains('locality')) {
                city = c['long_name'] as String? ?? '';
                break;
              }
              if (types.contains('administrative_area_level_1') && city.isEmpty) {
                city = c['long_name'] as String? ?? '';
              }
            }

            _cityName.value = city.isNotEmpty ? city : prediction.mainText;
            _address.value = result['formatted_address'] as String? ?? prediction.description;
          }
        }
      }
    } catch (_) {
      _reverseGeocode(_selectedLocation.value);
      return;
    }
    _loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Map
          ValueListenableBuilder<LatLng>(
            valueListenable: _selectedLocation,
            builder: (context, selected, _) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: selected,
                  zoom: 14,
                ),
                onMapCreated: (controller) => _mapController = controller,
                onTap: (latLng) {
                  _selectedLocation.value = latLng;
                  _reverseGeocode(latLng);
                  if (_showSearch.value) {
                    _showSearch.value = false;
                    _searchFocusNode.unfocus();
                    _predictions.value = [];
                  }
                },
                markers: {
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: selected,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
                  ),
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              );
            },
          ),

          // Search bar
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _onSearchChanged,
                    onTap: () => _showSearch.value = true,
                    decoration: InputDecoration(
                      hintText: S.of(context).searchPlaceHint,
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                      suffixIcon: ValueListenableBuilder<bool>(
                        valueListenable: _showSearch,
                        builder: (_, show, child) {
                          if (!show && _searchController.text.isEmpty) return const SizedBox.shrink();
                          return IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textLight),
                            onPressed: () {
                              _searchController.clear();
                              _predictions.value = [];
                              _showSearch.value = false;
                              _searchFocusNode.unfocus();
                            },
                          );
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),

                // Predictions list
                ValueListenableBuilder<List<_PlacePrediction>>(
                  valueListenable: _predictions,
                  builder: (_, preds, child2) {
                    if (preds.isEmpty) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(maxHeight: 260),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: preds.length,
                        separatorBuilder: (_, child3) =>
                            const Divider(height: 1, indent: 52),
                        itemBuilder: (_, index) {
                          final pred = preds[index];
                          return ListTile(
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.location_on_rounded,
                                  color: AppColors.primary, size: 18),
                            ),
                            title: Text(pred.mainText,
                                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                            subtitle: Text(pred.secondaryText,
                                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            dense: true,
                            onTap: () => _selectPrediction(pred),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // My location button
          Positioned(
            left: 16,
            bottom: 180,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.my_location_rounded,
                    color: AppColors.primary),
              ),
            ),
          ),

          // Bottom sheet with selected location info
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ValueListenableBuilder<bool>(
                valueListenable: _loading,
                builder: (context, loading, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.location_on_rounded,
                                color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: loading
                                ? const LinearProgressIndicator(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  )
                                : ValueListenableBuilder<String>(
                                    valueListenable: _cityName,
                                    builder: (_, city, child4) {
                                      return ValueListenableBuilder<String>(
                                        valueListenable: _address,
                                        builder: (_, addr, child5) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (city.isNotEmpty)
                                                Text(city,
                                                    style: AppTextStyles
                                                        .bodyLarge
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                              if (addr.isNotEmpty)
                                                Text(addr,
                                                    style: AppTextStyles
                                                        .bodySmall
                                                        .copyWith(
                                                            color: AppColors
                                                                .textSecondary)),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : () {
                                  final city = _cityName.value.isNotEmpty
                                      ? _cityName.value
                                      : _address.value.split('،').first.trim();
                                  Navigator.pop(
                                    context,
                                    PickedLocation(
                                      lat: _selectedLocation.value.latitude,
                                      lng: _selectedLocation.value.longitude,
                                      cityName: city.isNotEmpty
                                          ? city
                                          : '${_selectedLocation.value.latitude.toStringAsFixed(4)}, ${_selectedLocation.value.longitude.toStringAsFixed(4)}',
                                      address: _address.value,
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(S.of(context).confirmLocation),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
