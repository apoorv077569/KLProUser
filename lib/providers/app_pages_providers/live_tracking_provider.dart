import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:klpro_user/config.dart';
import 'package:klpro_user/utils/map_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTrackingProvider with ChangeNotifier {
  GoogleMapController? mapController;
  StreamSubscription? _trackingSubscription;
  StreamSubscription? _userLocationSubscription;

  LatLng? providerLocation;
  LatLng? userLocation;
  double providerRotation = 0.0;
  String? bookingId;
  
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  
  bool isLoading = true;

  // Initialization via screen's StatefulWrapper
  void onReady(context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    bookingId = args['bookingId']?.toString();
    if (bookingId != null) {
      initTracking(bookingId!);
    } else {
      log("Error: bookingId is null in arguments");
      isLoading = false;
      notifyListeners();
    }
  }

  void initTracking(String bId) async {
    bookingId = bId;
    isLoading = true;
    notifyListeners();

    // 1. Listen to Provider Movement from Firestore
    _trackingSubscription?.cancel();
    _trackingSubscription = FirebaseFirestore.instance
        .collection(collectionName.bookingTracking)
        .doc(bookingId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null &&
            data['providerLatitude'] != null &&
            data['providerLongitude'] != null) {
          providerLocation = LatLng(
            double.parse(data['providerLatitude'].toString()),
            double.parse(data['providerLongitude'].toString()),
          );
          providerRotation = double.parse((data['providerRotation'] ?? 0).toString());

          _updateMarkers();
          if (userLocation != null) {
            _getRoute();
            _animateToFit();
          }
        }
      }
      isLoading = false;
      notifyListeners();
    }, onError: (e) {
      log("Firestore tracking error: $e");
      isLoading = false;
      notifyListeners();
    });

    // 2. Track User's own location and push to Firestore
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        _userLocationSubscription?.cancel();
        _userLocationSubscription = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 1,
          ),
        ).listen((Position position) {
          userLocation = LatLng(position.latitude, position.longitude);
          _updateMarkers();

          // Push User Location to Firestore so Provider App can track us
          if (bookingId != null) {
            FirebaseFirestore.instance
                .collection(collectionName.bookingTracking)
                .doc(bookingId)
                .set({
              'latitude': position.latitude,
              'longitude': position.longitude,
              'updatedAt': DateTime.now().millisecondsSinceEpoch,
            }, SetOptions(merge: true));
          }

          if (providerLocation != null) {
            _getRoute();
            _animateToFit();
          }
          notifyListeners();
        });
      }
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (userLocation != null && providerLocation != null) {
      _animateToFit();
      _getRoute();
    } else if (userLocation != null) {
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(userLocation!, 15));
    }
    notifyListeners();
  }

  void _updateMarkers() {
    markers.clear();
    if (userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: userLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: "My Location"),
        ),
      );
    }
    if (providerLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('provider'),
          position: providerLocation!,
          rotation: providerRotation,
          anchor: const Offset(0.5, 0.5),
          flat: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: "Service Provider"),
        ),
      );
    }
  }

  Future<void> _getRoute() async {
    if (providerLocation == null || userLocation == null) return;
    
    final apiKey = appSettingModel?.firebase?.googleMapApiKey;
    if (apiKey == null || apiKey.isEmpty) return;

    try {
      final url = 'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${providerLocation!.latitude},${providerLocation!.longitude}'
          '&destination=${userLocation!.latitude},${userLocation!.longitude}'
          '&key=$apiKey';

      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          final routes = data['routes'] as List;
          if (routes.isNotEmpty) {
            final points = routes[0]['overview_polyline']['points'] as String;
            final decodedPoints = MapUtils.decodePolyline(points);
            
            polylines = {
              Polyline(
                polylineId: const PolylineId('route'),
                points: decodedPoints,
                color: const Color(0xFF2196F3),
                width: 6,
                jointType: JointType.round,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
              )
            };
            notifyListeners();
          }
        } else {
           log("Directions API Error Status: ${data['status']} - ${data['error_message'] ?? 'No error message'}");
           _setFallbackPolyline();
        }
      }
    } catch (e) {
      log('Directions Error: $e');
      _setFallbackPolyline();
    }
  }

  void _setFallbackPolyline() {
    if (providerLocation == null || userLocation == null) return;
    polylines = {
      Polyline(
        polylineId: const PolylineId('route_fallback'),
        points: [providerLocation!, userLocation!],
        color: const Color(0xFF5465FF).withOpacity(0.5),
        width: 3,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      )
    };
    notifyListeners();
  }

  void _animateToFit() {
    if (mapController == null || userLocation == null || providerLocation == null) return;

    double south = userLocation!.latitude < providerLocation!.latitude ? userLocation!.latitude : providerLocation!.latitude;
    double north = userLocation!.latitude > providerLocation!.latitude ? userLocation!.latitude : providerLocation!.latitude;
    double west = userLocation!.longitude < providerLocation!.longitude ? userLocation!.longitude : providerLocation!.longitude;
    double east = userLocation!.longitude > providerLocation!.longitude ? userLocation!.longitude : providerLocation!.longitude;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );

    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  @override
  void dispose() {
    _trackingSubscription?.cancel();
    _userLocationSubscription?.cancel();
    // Do not dispose mapController here if it's already managed by GoogleMap widget or if it might cause issues on rebuild
    super.dispose();
  }
}
