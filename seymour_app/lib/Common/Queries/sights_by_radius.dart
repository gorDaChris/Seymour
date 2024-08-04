import 'package:flutter_overpass/flutter_overpass.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:seymour_app/Common/Models/coordinate.dart';
import 'dart:async';

import 'package:seymour_app/Common/Models/sight.dart';

final flutterOverpass = FlutterOverpass();

Future<List<Sight>> getSights(LatLng center, double radius) async {
  final queryResult = await flutterOverpass.rawOverpassQL(
      query: "node(around:$radius,${center.latitude},${center.longitude});");

  List<Sight> nearby = [];

  for (dynamic node in queryResult["elements"]) {
    if (node["tags"] != null &&
        node["tags"]["tourism"] != null &&
        node["tags"]["name"] != null) {
      nearby.add(Sight(
          node["tags"]["name"],
          Coordinate(node["lat"], node["lon"]),
          node["tags"]["tourism"],
          node["tags"]["wikipedia"]));
    }
  }

  // DEBUG
  // log(nearby.toString());

  return nearby;
}
