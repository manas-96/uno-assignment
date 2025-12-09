import 'package:hive_flutter/hive_flutter.dart';
import 'package:uno_assignment/models/location_data.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  late Box<LocationData> _locationBox;

  Future<void> init() async {
    _locationBox = await Hive.openBox<LocationData>('locations');
  }

  Future<void> saveLocation(LocationData locationData) async {
    await _locationBox.add(locationData);
  }

  List<LocationData> getAllLocations() {
    return _locationBox.values.toList();
  }

  Future<void> clearAllLocations() async {
    await _locationBox.clear();
  }
}
