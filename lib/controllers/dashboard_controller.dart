import 'dart:async';
import 'package:get/get.dart';
import 'package:uno_assignment/models/location_data.dart';
import 'package:uno_assignment/services/location_service.dart';
import 'package:uno_assignment/services/notification_service.dart';
import 'package:uno_assignment/services/storage_service.dart';

class DashboardController extends GetxController {
  final LocationService _locationService = LocationService();
  final NotificationService _notificationService = NotificationService();
  final StorageService _storageService = StorageService();

  var isTracking = false.obs;
  var locations = <LocationData>[].obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _notificationService.init();
    _storageService.init().then((_) {
      locations.value = _storageService.getAllLocations();
    });
  }

  void startTracking() async {
    isTracking.value = true;
    _fetchAndSaveLocation(isInitial: true);
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      _fetchAndSaveLocation();
    });
  }

  void stopTracking() {
    isTracking.value = false;
    _timer?.cancel();
    _storageService.clearAllLocations();
    locations.clear();
  }

  void _fetchAndSaveLocation({bool isInitial = false}) async {
    try {
      LocationData locationData = await _locationService.getCurrentLocation();
      _storageService.saveLocation(locationData);
      locations.add(locationData);
      final title = isInitial ? 'Tracking Started' : 'Location Updated';
      _notificationService.showNotification(locationData, title);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
