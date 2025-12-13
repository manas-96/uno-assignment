import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String> getAddressFromLatLng(Position position) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return "${place.locality}, ${place.postalCode}, ${place.country}";
  } catch (e) {
    return "Address not found";
  }
}
