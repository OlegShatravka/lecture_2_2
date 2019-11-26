import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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
        Position position = await geoLocator.getLastKnownPosition(
            desiredAccuracy: LocationAccuracy.high);
        if (position == null) {
          Future(() async {
            position = await geoLocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.lowest);
          }).timeout(Duration(seconds: 5), onTimeout: () async {
            position = await geoLocator.getLastKnownPosition(
                desiredAccuracy: LocationAccuracy.high);
          });
        }

        final double distanceMeters = await geoLocator.distanceBetween(
            userLatitude, userLongitude, position.latitude, position.longitude);

        return distanceMeters / 1000;
      } else {
        throw GpsNotEnabledError();
      }
    } on PlatformException {
      throw PermissionNotGranted();
    }
  }
}
