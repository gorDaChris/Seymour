import 'package:latlong2/latlong.dart';

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

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  @override
  String toString() {
    return "Latitude: $latitude, Longitude: $longitude";
  }

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}

extension ToCoord on LatLng {
  Coordinate toCoordinate() {
    return Coordinate(latitude, longitude);
  }
}
