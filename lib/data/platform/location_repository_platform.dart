import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:lecture_2_2/domain/error/gps_not_enabled_error.dart';
import 'package:lecture_2_2/domain/error/permission_not_granted.dart';
import 'package:lecture_2_2/domain/repository/location_repository.dart';
import 'package:location_permissions/location_permissions.dart';

class LocationRepositoryPlatform extends LocationRepository {
  @override
  Future<num> calculateDistanceToUser(
      double userLatitude, double userLongitude) async {
    try {
      await LocationPermissions().requestPermissions();
      final geoLocator = Geolocator();
      if (await geoLocator.isLocationServiceEnabled()) {
        final position = await geoLocator.getLastKnownPosition(
            desiredAccuracy: LocationAccuracy.high);

        return Distance().as(
            LengthUnit.Kilometer,
            LatLng(position.latitude, position.longitude),
            LatLng(userLatitude, userLongitude));
      } else {
        throw GpsNotEnabledError();
      }
    } on PlatformException {
      throw PermissionNotGranted();
    }
  }
}
