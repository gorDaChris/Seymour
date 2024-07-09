import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:seymour_app/Views/map_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  PanelController _pc = new PanelController();

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
      CircleMarker(point: LatLng(0, 0), radius: 10);

  void interpretLocation(LocationData data) {
    displayUserLocationCircle(data);
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

  late StreamSubscription<LocationData> locationStreamSubscription;

  @override
  void initState() {
    super.initState();
    //A route must exist before we get to this page
    routeLine = currentJourney.route!.drawRoute().first;

    locationStreamSubscription =
        Location().onLocationChanged.listen(interpretLocation);
  }

  Polyline<Object> routeLine = Polyline(points: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
            isDraggable: false,
            panelSnapping: true,
            controller: _pc,
            body: FutureBuilder<LocationData?>(
                future: currentLocation(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
                  if (snapchat.hasData) {
                    final LocationData currentLocation = snapchat.data;
                    return FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(currentLocation.latitude!,
                              currentLocation.longitude!),
                          initialZoom: 17,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          PolylineLayer(polylines: [routeLine]),
                          CircleLayer(circles: [userLocationMarker])
                        ]);
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            // This is the "arrived at destination" screen
            // TODO: What are we even going to do for this?
            // TODO: Button that calls _hideDestinationMenu
            // TODO: Darkened background
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
                      Text("IMAGE"),
                      Column(children: <Widget>[
                        Text("100ft - Turn left",
                            textScaler: TextScaler.linear(2)),
                        Text("Example Dr.", textScaler: TextScaler.linear(1.5))
                      ]),
                      Column(children: <Widget>[
                        ElevatedButton(
                            child: const Text("Go back"),
                            onPressed: () {
                              navigateToMapPage();
                            })
                      ])
                    ]))));
  }
}
