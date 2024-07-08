class Coordinate {
  double latitude;
  double longitude;

  Coordinate(this.latitude, this.longitude);

  factory Coordinate.fromJsonAzure(Map<String, dynamic> json) {
    return Coordinate(
      json['latitude'],
      json['longitude'],
    );
  }

  @override
  String toString() {
    return "Latitude: $latitude, Longitude: $longitude";
  }
}
