import 'package:flutter_overpass/flutter_overpass.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:seymour_app/Common/Models/coordinate.dart';
import 'package:seymour_app/Common/Models/filtered_tags.dart';
import 'dart:async';

import 'package:seymour_app/Common/Models/sight.dart';

final flutterOverpass = FlutterOverpass();

Future<bool> matchesFilters(dynamic node) async {
  if (node["tags"] == null || 
      node["tags"]["tourism"] == null || 
      node["tags"]["name"] == null) {
        return false;
  }

  if (node["tags"]["tourism"] == "artwork") {
    /// If the sight is of type "artwork", then filter based on artwork type
    if (FilteredTags.tags[node["tags"]["artwork_type"]] != null &&
        FilteredTags.tags[node["tags"]["artwork_type"]]!.filtered) { 
      return true;
    }
  } else {
    if (FilteredTags.tags[node["tags"]["tourism"]] != null &&
        FilteredTags.tags[node["tags"]["tourism"]]!.filtered) {
      return true;
    }
  }
  return false;
}

Future<List<Sight>> getSights(LatLng center, double radius) async {
  final queryResult = await flutterOverpass.rawOverpassQL(
      query: "node(around:$radius,${center.latitude},${center.longitude});");

  List<Sight> nearby = [];

  for (dynamic node in queryResult["elements"]) {
    if (await matchesFilters(node)) {
      if (node["tags"]["tourism"] == "artwork") { 
        nearby.add(Sight(
            node["tags"]["name"],
            Coordinate(node["lat"], node["lon"]),
            "artwork",
            node["tags"]["artwork_type"],
            node["tags"]["wikipedia"]));
      } else {
        nearby.add(Sight(
            node["tags"]["name"],
            Coordinate(node["lat"], node["lon"]),
            node["tags"]["tourism"],
            null,
            node["tags"]["wikipedia"]));
      }
    }
  }
  return nearby;
}
