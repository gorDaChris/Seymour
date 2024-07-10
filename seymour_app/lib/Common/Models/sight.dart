import 'package:seymour_app/Common/Models/coordinate.dart';
import 'package:flutter_overpass/flutter_overpass.dart';

///
/// WIP
///
class Sight {
  String name;
  Tag tag; // Temporary
  Coordinate coordinate;

  Sight(this.name, this.coordinate, this.tag);

  @override
  String toString() {
    return "Name: $name, Coordinate: $coordinate";
  }
}