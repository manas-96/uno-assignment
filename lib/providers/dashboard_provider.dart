import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uno_assignment/models/location_data.dart';
import 'package:uno_assignment/services/storage_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uno_assignment/services/notification_service.dart';
import 'package:uno_assignment/utils/location_utils.dart';

class DashboardState {
  final bool isTracking;
  final List<LocationData> locations;

  DashboardState({this.isTracking = false, this.locations = const []});

  DashboardState copyWith({bool? isTracking, List<LocationData>? locations}) {
    return DashboardState(
      isTracking: isTracking ?? this.isTracking,
      locations: locations ?? this.locations,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();
  final _backgroundService = FlutterBackgroundService();

  DashboardNotifier() : super(DashboardState()) {
    _storageService.init().then((_) {
      state = state.copyWith(locations: _storageService.getAllLocations());
      Hive.box<LocationData>('locations').listenable().addListener(() {
        state = state.copyWith(locations: _storageService.getAllLocations());
      });
    });
    _notificationService.init();
  }

  void startTracking() async {
    Position position = await Geolocator.getCurrentPosition();
    String address = await getAddressFromLatLng(position);
    final locationData = LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
      timestamp: DateTime.now(),
    );
    await _storageService.saveLocation(locationData);
    _notificationService.showNotification(locationData, 'Tracking Started');

    _backgroundService.startService();
    state = state.copyWith(isTracking: true);
  }

  void stopTracking() {
    _backgroundService.invoke("stopService");
    _storageService.clearAllLocations();
    state = state.copyWith(isTracking: false, locations: []);
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>(
        (ref) => DashboardNotifier());
