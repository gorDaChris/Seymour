import 'package:seymour_app/Common/Models/coordinate.dart';

///
/// WIP
///
class Sight {
  final String _name;
  final String _tourismType;
  final String? _artworkType;
  final Coordinate _coordinate;

  final String? _wikipediaTitle;

  Sight(this._name, this._coordinate, this._tourismType, this._artworkType,
      this._wikipediaTitle);

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

  bool isArtwork() {
    return _artworkType != null;
  }

  factory Sight.fromJson(Map<String, dynamic> json) {
    return Sight(
      json['name'],
      Coordinate.fromJsonAzure(json['coordinate']),
      json['tourismType'],
      json["artworkType"],
      json['wikipediaTitle'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': _name,
        'tourismType': _tourismType,
        'coordinate': _coordinate,
        'wikipediaTitle': _wikipediaTitle,
        "artworkType": _artworkType
      };
}
