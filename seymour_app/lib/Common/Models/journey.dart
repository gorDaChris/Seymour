import 'package:seymour_app/Common/Models/coordinate.dart';
import 'package:seymour_app/Common/Models/route.dart';
import 'package:seymour_app/Common/Models/sight.dart';

class Journey {
  Route? route;

  final List<Sight> _currentSights = [];

  Coordinate? mapCenter;

  List<Sight> sights() {
    return List.unmodifiable(_currentSights);
  }

  void setSights(List<Sight> newSights) {
    _currentSights.clear();
    _currentSights.addAll(newSights);
  }

  bool isEmpty() {
    return _currentSights.isEmpty;
  }

  void addSight(Sight sight) {
    _currentSights.add(sight);
  }

  Sight removeSight(int index) {
    return _currentSights.removeAt(index);
  }

  Journey();
  Journey.fromRoute(this.route);

  factory Journey.fromJson(Map<String, dynamic> json) {
    Journey journey;

    if (json['route'] != null) {
      journey = Journey.fromRoute(Route.fromJson(json['route']));
    } else {
      journey = Journey();
    }

    journey.setSights(
        (json['currentSights'] as List).map((i) => Sight.fromJson(i)).toList());

    journey.mapCenter = Coordinate.fromJsonAzure(json["mapCenter"]);

    return journey;
  }

  Map<String, dynamic> toJson() => {
        'route': route?.toJson(),
        'currentSights': _currentSights,
        "mapCenter": mapCenter?.toJson()
      };
}
