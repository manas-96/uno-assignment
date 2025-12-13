import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uno_assignment/models/location_data.dart';
import 'package:uno_assignment/services/notification_service.dart';
import 'package:uno_assignment/services/storage_service.dart';
import 'package:uno_assignment/utils/location_utils.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final notificationService = NotificationService();
  final storageService = StorageService();

  await notificationService.init();
  await storageService.init();

  final timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
    Position position = await Geolocator.getCurrentPosition();
    String address = await getAddressFromLatLng(position);

    final locationData = LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
      timestamp: DateTime.now(),
    );

    await storageService.saveLocation(locationData);
    notificationService.showNotification(locationData, 'Location Updated');
  });

  service.on('stopService').listen((event) {
    timer.cancel();
    service.stopSelf();
  });
}
