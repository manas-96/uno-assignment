import 'package:hive/hive.dart';

part 'location_data.g.dart';

@HiveType(typeId: 0)
class LocationData extends HiveObject {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final DateTime timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.timestamp,
  });
}
