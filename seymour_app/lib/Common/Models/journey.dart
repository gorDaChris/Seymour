import 'package:seymour_app/Common/Models/route.dart';
import 'package:seymour_app/Common/Models/sight.dart';

class Journey {
  Route? route;

  final List<Sight> _currentSights = [];

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

/*
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sights'] = _currentSights.map((obj) => obj.toJson()).toList();

    return data;
  }*/

  factory Journey.fromJson(Map<String, dynamic> json) {
    Journey journey = Journey.fromRoute(Route.fromJson(json['route']));
    Journey journey;

    if (json['route'] != null) {
      journey = Journey.fromRoute(Route.fromJson(json['route']));
    }
    else {
      journey = Journey();
    }

    journey.setSights((json['currentSights'] as List)
      .map((i) => Sight.fromJson(i))
      .toList());
    return journey;
  }

  Map<String, dynamic> toJson() => {
    'route': route?.toJson(),
    'currentSights': _currentSights,
  };
}
