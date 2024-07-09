import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:seymour_app/Common/Models/coordinate.dart';

import 'package:seymour_app/Common/Models/route.dart';

Future<Route> coordinatesToRoute(
    List<Coordinate> coordinates, bool maintainOrder) async {
  //Coordinates need to be formatted for Azure
  String queryCoordinates = "";

  for (var coordinate in coordinates) {
    queryCoordinates += "${coordinate.latitude},${coordinate.longitude}:";
  }

  queryCoordinates = queryCoordinates.substring(0, queryCoordinates.length - 1);

  Response response =
      await get(Uri.https("atlas.microsoft.com", "/route/directions/json", {
    "api-version": "1.0",
    "query": queryCoordinates,
    "travelMode": "pedestrian",
    "instructionsType": "tagged",
    "subscription-key": await rootBundle.loadString("DoNotPutIntoGitAzure.txt"),
    "computeBestOrder": (!maintainOrder).toString()
  }));

  log(response.body);

  var jsonObject = jsonDecode(response.body);

  return Route.fromJson(jsonObject["routes"][0]);
}
