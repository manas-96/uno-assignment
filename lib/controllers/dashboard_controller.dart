import 'package:get/get.dart';
import 'package:uno_assignment/models/location_data.dart';
import 'package:uno_assignment/services/background_location_service.dart';
import 'package:uno_assignment/services/location_service.dart';
import 'package:uno_assignment/services/notification_service.dart';
import 'package:uno_assignment/services/storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DashboardController extends GetxController {
  final LocationService _locationService = Get.put(LocationService());
  final NotificationService _notificationService = Get.put(NotificationService());
  final StorageService _storageService = Get.put(StorageService());
  final BackgroundLocationService _backgroundLocationService = Get.put(BackgroundLocationService());

  var isTracking = false.obs;
  var locations = <LocationData>[].obs;

  @override
  void onInit() {
    super.onInit();
    _notificationService.init();
    _storageService.init().then((_) {
      locations.value = _storageService.getAllLocations();
      Hive.box<LocationData>('locations').listenable().addListener(() {
        locations.value = _storageService.getAllLocations();
      });
    });
  }

  void startTracking() async {
    isTracking.value = true;
    _backgroundLocationService.start();
  }

  void stopTracking() {
    isTracking.value = false;
    _backgroundLocationService.stop();
    _storageService.clearAllLocations();
    locations.clear();
  }

  @override
  void onClose() {
    _backgroundLocationService.stop();
    super.onClose();
  }
}
