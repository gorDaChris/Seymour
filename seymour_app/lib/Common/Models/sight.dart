import 'package:seymour_app/Common/Models/coordinate.dart';
import 'package:flutter_overpass/flutter_overpass.dart';

///
/// WIP
///
class Sight {
  final String _name;
  final String _tourismType;
  final Coordinate _coordinate;

  String? _wikipediaTitle;

  Sight(this._name, this._coordinate, this._tourismType, this._wikipediaTitle);

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

  String? getWikipediaTitle() {
    return _wikipediaTitle;
  }

  factory Sight.fromJson(Map<String, dynamic> json) {
    return Sight(
      _name = json['name'],
      _tourismType = json['tourismType'],
      _coordinate = Coordinate.fromJsonAzure(json['coordinate']),
      _wikipediaTitle = json['wikipediaTitle'],
    );
  }
}
