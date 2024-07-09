import 'package:flutter_overpass/flutter_overpass.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'dart:developer';

final flutterOverpass = FlutterOverpass();

Future<void> getSights(LatLng center, double radius) async {
  final result = await flutterOverpass.getNearbyNodes(
    latitude: center.latitude,
    longitude: center.longitude,
    radius: radius
  );

  log("result: $result");
}