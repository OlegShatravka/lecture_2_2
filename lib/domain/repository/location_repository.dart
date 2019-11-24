abstract class LocationRepository {

  ///distance in km
  Future<num> calculateDistanceToUser(double userLatitude, double userLongitude);
}
