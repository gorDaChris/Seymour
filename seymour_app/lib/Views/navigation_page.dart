import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:seymour_app/Common/Models/route.dart';
import 'package:seymour_app/Common/Models/sight.dart';
import 'package:seymour_app/Common/Queries/readWikipediaArticleAloud.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:seymour_app/Views/map_page.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  PanelController _pc = new PanelController();

  int instructionIndex = 1;

  Instruction currentInstruction =
      currentJourney.route!.guidance.instructions[1];

  void navigateToMapPage() {
    locationStreamSubscription.cancel();
    Navigator.of(context).pop();
  }

  void _toggleDestinationMenu() {
    if (_pc.isPanelOpen) {
      _pc.close();
    } else {
      _pc.open();
    }
  }

  CircleMarker userLocationMarker =
      const CircleMarker(point: LatLng(0, 0), radius: 10);

  void interpretLocation(LocationData data) {
    displayUserLocationCircle(data);
    changeCurrentInstructionIfNeeded(data);
  }

  void displayUserLocationCircle(LocationData data) {
    setState(() {
      userLocationMarker = CircleMarker(
          point: LatLng(data.latitude!, data.longitude!),
          radius: 7,
          color: Colors.blue,
          borderColor: Colors.red,
          borderStrokeWidth: 3);
    });
  }

  void changeCurrentInstructionIfNeeded(LocationData data) {
    double userDistanceFromNextStepMeters = const Distance().as(
        LengthUnit.Meter,
        LatLng(data.latitude!, data.longitude!),
        currentInstruction.point.toLatLng());

    if (userDistanceFromNextStepMeters <= 20) {
      instructionIndex++;
      if (instructionIndex >=
          currentJourney.route!.guidance.instructions.length) {
        //Final destination reached!
        return;
      }

      setState(() {
        currentInstruction =
            currentJourney.route!.guidance.instructions[instructionIndex];
      });
      print(currentInstruction.maneuver);
    }
  }

  String getDistanceToDisplay(LatLng source, LatLng dest) {
    double dist = const Distance().as(
        LengthUnit.Meter,
        source,
        dest);
        
    int time = ((dist / 1.34) / 60).floor();

    return dist.toString() + "m   " + time.toString() + "mins";
  }

  late StreamSubscription<LocationData> locationStreamSubscription;

  @override
  void initState() {
    super.initState();
    //A route must exist before we get to this page
    routeLines = currentJourney.route!.drawRoute();

    Location().changeSettings(interval: 20000);

    locationStreamSubscription =
        Location().onLocationChanged.listen(interpretLocation);
  }

  List<Polyline<Object>> routeLines = [];

  String? formatInstructionMessage(String? message) {
    return message?.replaceAll("<street>", "").replaceAll("</street>", "");
  }

  Map<String, IconData> maneuverIcons = {
    "TURN_LEFT": Icons.turn_left,
    "STRAIGHT": Icons.straight,
    "BEAR_LEFT": Icons.turn_slight_left,
    "ROUNDABOUT_LEFT": Icons.roundabout_left,
    "TURN_RIGHT": Icons.turn_right,
    "BEAR_RIGHT": Icons.turn_slight_right,
    "ROUNDABOUT_Right": Icons.roundabout_right
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
          isDraggable: false,
          panelSnapping: true,
          controller: _pc,
          body: FutureBuilder<LocationData?>(
              future: currentLocation(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
                if (snapchat.hasData) {
                  final LocationData currentLocation = snapchat.data;
                  return FlutterMap(
                      options: MapOptions(
                        initialCenter: currentJourney
                            .route!.legs.first.points.first
                            .toLatLng(),
                        initialZoom: 17,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        PolylineLayer(polylines: [...routeLines]),
                        CircleLayer(circles: [userLocationMarker]),
                        MarkerLayer(
                          markers: currentJourney
                              .sights()
                              .map((Sight sight) => Marker(
                                  point: sight.getCoordinate().toLatLng(),
                                  child: CustomPopup(
                                      content: SizedBox(
                                          width: 200,
                                          height: 200,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // mainAxisAlignment:
                                              //     // MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(sight.name(),
                                                    textScaler:
                                                        TextScaler.linear(1.2)),
                                                ElevatedButton(
                                                    onPressed:
                                                        sight.getWikipediaTitle() ==
                                                                null
                                                            ? null
                                                            : () async {
                                                                await launchUrl(
                                                                    Uri.https(
                                                                        "en.wikipedia.org",
                                                                        "/wiki/${sight.getWikipediaTitle()}"),
                                                                    mode: LaunchMode
                                                                        .inAppBrowserView);
                                                              },
                                                    child: const Text("Open in Wikipedia"),
                                                ),
                                                ElevatedButton(
                                                    onPressed:
                                                        sight.getWikipediaTitle() ==
                                                                null
                                                            ? null
                                                            : () {
                                                                readWikipediaArticleAloud(
                                                                    sight
                                                                        .getWikipediaTitle()!);
                                                              },
                                                    child: const Text(
                                                        "Read wikipedia audio guide aloud"))
                                              ])
                                            ),
                                        child: const Icon(
                                          Icons.location_pin,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                      )
                                    )
                                  ).toList(),
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: currentJourney.route!.legs.last.points.last.toLatLng(),
                              child: const Icon(
                                Icons.flag_circle,
                                size: 30,
                                color: Colors.red,
                              )
                            ),
                          ],
                        ),
                      ]);
                }
                return const Center(child: CircularProgressIndicator());
              }),
          panel: Container(
              color: Colors.grey,
              child: Column(children: <Widget>[
                const Text("YOU'RE HERE", textScaler: TextScaler.linear(2)),
                ElevatedButton(
                    child: const Text("Raise/lower demo"),
                    onPressed: () {
                      _toggleDestinationMenu();
                    })
              ])),
          // These are the navigation instructions
          // TODO: Global button that calls _showDestinationMenu
          collapsed: Container(
              color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      maneuverIcons[currentInstruction.maneuver] ?? Icons.error,
                      size: 40,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              formatInstructionMessage(
                                      currentInstruction.street) ??
                                  "",
                              textScaler: TextScaler.linear(1.2)),

                          // Text("Example Dr.", textScaler: TextScaler.linear(1.5))
                        ]),

                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              //TODO: put distance and time here
                              getDistanceToDisplay(currentJourney
                            .route!.legs.first.points.first.toLatLng(), currentJourney
                            .route!.legs.last.points.last.toLatLng()),
                              textScaler: TextScaler.linear(1.2)),
                        ]),
                    ElevatedButton(
                        child: const Text("Go back"),
                        onPressed: () {
                          navigateToMapPage();
                        })
                  ]))),
      floatingActionButton:
          ElevatedButton(child: Icon(Icons.stop), onPressed: FlutterTts().stop),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
