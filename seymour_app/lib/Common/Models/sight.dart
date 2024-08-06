import 'package:seymour_app/Common/Models/coordinate.dart';

///
/// WIP
///
class Sight {
  final String _name;
  final String _tourismType;
  final Coordinate _coordinate;

  final String? _wikipediaTitle;

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
      json['name'],
      Coordinate.fromJsonAzure(json['coordinate']),
      json['tourismType'],
      json['wikipediaTitle'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': _name,
    'tourismType': _tourismType,
    'coordinate': _coordinate,
    'wikipediaTitle': _wikipediaTitle,
  };
}
