import 'package:seymour_app/Common/Models/sight.dart';

//
// WIP; does not have routing variables
//
class CurrentJourney {
  static final CurrentJourney _instance = CurrentJourney._constructor();
  final List<Sight> _currentSights = [];

  CurrentJourney._constructor();

  factory CurrentJourney() {
    return _instance;
  }

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