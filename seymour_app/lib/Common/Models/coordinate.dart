class Coordinate {
  double latitude;
  double longitude;

  Coordinate(this.latitude, this.longitude);

  @override
  String toString() {
    return "Latitude: $latitude, Longitude: $longitude";
  }
}
