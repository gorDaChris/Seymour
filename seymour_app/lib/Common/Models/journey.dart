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
}
