import 'package:seymour_app/Common/Models/coordinate.dart';
import 'package:flutter_overpass/flutter_overpass.dart';

///
/// WIP
///
class Sight {
  final String _name;
  final Tag _tag; // WIP
  final Coordinate _coordinate;

  Sight(this._name, this._coordinate, this._tag);

  @override
  String toString() {
    return "Name: $_name, Coordinate: $_coordinate";
  }

  String name() {
    return _name;
  }

  Coordinate getCoordinate() {
    return _coordinate;
  }
}
