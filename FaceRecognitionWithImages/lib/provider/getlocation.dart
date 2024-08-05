// location_provider.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {
  double? latitude;
  double? longitude;
  String? postalCode;
  String? sublocality;
  String? administrativeArea;
  String? locality;
  String? country;

  String get workLocation {
    String location = '';

    if (sublocality != null) location += sublocality! + ', ';
    if (administrativeArea != null) location += administrativeArea! + ', ';
    if (locality != null) location += locality! + ', ';
    if (country != null) location += country! + ', ';
    if (postalCode != null) location += postalCode!;

    return location.isNotEmpty ? location : 'Unknown';
  }

  Future<void> getDeviceInfo() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!);

      postalCode = placemarks.first.postalCode ?? "";
      sublocality = placemarks.first.subLocality ?? "";
      administrativeArea = placemarks.first.administrativeArea ?? "";
      locality = placemarks.first.locality ?? "";
      country = placemarks.first.country ?? "";

      print("LATITUDE: $latitude");
      print("LONGITUDE: $longitude");
      print("POSTAL CODE: $postalCode");
      print("SUBLOCALITY: $sublocality");
      print("ADMINISTRATIVE AREA: $administrativeArea");
      print("LOCALITY: $locality");
      print("COUNTRY: $country");
      print("WORK LOCATION: $workLocation");

      notifyListeners();
    } catch (e) {
      print("Error getting device info: $e");
    }
  }
}
