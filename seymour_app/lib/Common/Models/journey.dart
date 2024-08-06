import 'package:seymour_app/Common/Models/route.dart';
import 'package:seymour_app/Common/Models/sight.dart';

class Journey {
  Route? route;

  final List<Sight> _currentSights = [];

  Journey();
  Journey.fromRoute(this.route);

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

  factory Journey.fromJson(Map<String, dynamic> json) {
    Journey journey = Journey.fromRoute(Route.fromJson(json['route']));

    journey.setSights((json['currentSights'] as List)
      .map((i) => Sight.fromJson(i))
      .toList());

    return journey;
  }

  Map<String, dynamic> toJson() => {
    'route': route,
    'currentSights': _currentSights,
  };
}
