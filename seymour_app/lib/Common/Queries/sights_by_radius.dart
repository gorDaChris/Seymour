import 'package:flutter_overpass/flutter_overpass.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:seymour_app/Common/Models/coordinate.dart';
import 'dart:async';
import 'dart:developer'; // for log()

import 'package:seymour_app/Common/Models/sight.dart';

final flutterOverpass = FlutterOverpass();

Future<List<Sight>> getSights(LatLng center, double radius) async {
  final result = await flutterOverpass.getNearbyNodes(
      latitude: center.latitude, longitude: center.longitude, radius: radius);

  List<Element>? queryResults = result.elements;

  if (queryResults == null || queryResults.isEmpty) {
    // HANDLE NULL
    return List.empty();
  }

  List<Sight> nearby = [];
  for (var i = 0; i < queryResults.length; i++) {
    Element element = queryResults[i];

    // Ensure null safety
    if (element.lat == null || element.lon == null) {
      continue;
    }
    if (element.tags == null || element.tags?.name == null) {
      continue;
    }

    String? name = element.tags?.name;
    name ??= "";

    nearby.add(
        Sight(name, Coordinate(element.lat!, element.lon!), element.tags!));
  }

  // DEBUG
  log(nearby.toString());

  return nearby;
}
