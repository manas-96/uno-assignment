import 'package:flutter_background_location/flutter_background_location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uno_assignment/models/location_data.dart';
import 'package:uno_assignment/services/notification_service.dart';
import 'package:uno_assignment/services/storage_service.dart';
import 'package:get/get.dart';

class BackgroundLocationService {
  final NotificationService _notificationService = Get.find();
  final StorageService _storageService = Get.find();

  void start() {
    BackgroundLocation.startLocationService();
    BackgroundLocation.getLocationUpdates((location) async {
      try {
        String address = await _getAddressFromLatLng(location);
        final locationData = LocationData(
          latitude: location.latitude!,
          longitude: location.longitude!,
          address: address,
          timestamp: DateTime.now(),
        );
        await _storageService.saveLocation(locationData);
        _notificationService.showNotification(locationData, "Location Updated");
      } catch (e) {
        print('Error in background location service: $e');
      }
    });
  }

  Future<String> _getAddressFromLatLng(Location location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude!, location.longitude!);

      Placemark place = placemarks[0];

      return "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      return "Address not found";
    }
  }

  void stop() {
    BackgroundLocation.stopLocationService();
  }
}
