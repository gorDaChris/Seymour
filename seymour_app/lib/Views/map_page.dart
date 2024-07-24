import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:seymour_app/Common/Models/coordinate.dart';
import 'package:seymour_app/Common/Models/journey.dart';

import 'package:seymour_app/Common/Models/sight.dart';
import 'package:seymour_app/Common/Queries/address_to_coordinates.dart';
import 'package:seymour_app/Common/Queries/coordinates_to_route.dart';
import 'package:seymour_app/Common/Queries/sights_by_radius.dart';
import 'package:seymour_app/Views/draggable_menu.dart';
import 'package:seymour_app/Views/save_page.dart';
import 'package:seymour_app/Views/navigation_page.dart';

Journey currentJourney = Journey();

const STARTING_MILES_RADIUS = 0.5;
const METERS_IN_A_MILE = 1609.34;

Future<LocationData?> currentLocation() async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  Location location = Location();

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }
  return await location.getLocation();
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool firstBuild = true;

  TextEditingController topTextController = TextEditingController();
  TextEditingController bottomTextController = TextEditingController();

  late LatLng center;

  Coordinate? topCoordinate;
  Coordinate? bottomCoordinate;

  double _turnsShowBottomTextFieldButton = 0;
  bool _showBottomTextField = false;

  static final MapController _mapController = MapController();

  void navigateToImportExportSavePage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SavePage()));
  }

  void navigateToNavigationPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NavigationPage()));
  }

  void _handleShowSideButtons() {
    _showAllSideButtons = !_showAllSideButtons;
    if (_showAllSideButtons) {
      setState(() {
        _showSideButtonsButtonTurns = 0.125;
      });

      _sideButtons.add(Card(
        child: IconButton(
          onPressed: () async {
            currentJourney.route = await coordinatesToRoute(
                currentJourney
                    .sights()
                    .map((Sight s) => s.getCoordinate())
                    .toList(),
                _showBottomTextField);

            setState(() {
              routeLines = currentJourney.route!.drawRoute();
            });
          },
          icon: const Icon(Icons.route),
        ),
      ));

      _listKey.currentState?.insertItem(0);

      _sideButtons.add(Card(
        child: IconButton(
          onPressed: () {
            navigateToImportExportSavePage();
          },
          icon: const Icon(Icons.ios_share),
        ),
      ));

      _listKey.currentState?.insertItem(1);

      _sideButtons.add(Card(
        child: IconButton(
          onPressed: () {
            navigateToNavigationPage();
          },
          icon: const Icon(Icons.navigation),
        ),
      ));

      _listKey.currentState?.insertItem(2);

      _sideButtons.add(Card(
        child: IconButton(
          onPressed: () {
            // TODO: Note this is TEMPORARY BEHAVIOR!
            getNearbySights();
          },
          icon: const Icon(Icons.map),
        ),
      ));

      _listKey.currentState?.insertItem(3);
    } else {
      setState(() {
        _showSideButtonsButtonTurns = 0;
      });

      _sideButtons.removeAt(0);
      _listKey.currentState?.removeItem(0, (context, animation) {
        return SlideTransition(
          position: animation
              .drive(Tween(begin: const Offset(3, 0), end: const Offset(0, 0))),
          child: Card(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.route),
            ),
          ),
        );
      });
      _sideButtons.removeAt(0);
      _listKey.currentState?.removeItem(0, (context, animation) {
        return SlideTransition(
          position: animation
              .drive(Tween(begin: const Offset(3, 0), end: const Offset(0, 0))),
          child: Card(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.ios_share),
            ),
          ),
        );
      });

      _sideButtons.removeAt(0);
      _listKey.currentState?.removeItem(0, (context, animation) {
        return SlideTransition(
          position: animation
              .drive(Tween(begin: const Offset(3, 0), end: const Offset(0, 0))),
          child: Card(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.navigation),
            ),
          ),
        );
      });

      _sideButtons.removeAt(0);
      _listKey.currentState?.removeItem(0, (context, animation) {
        return SlideTransition(
          position: animation
              .drive(Tween(begin: const Offset(3, 0), end: const Offset(0, 0))),
          child: Card(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.map),
            ),
          ),
        );
      });
    }
  }

  final List<Widget> _sideButtons = [];

  final _listKey = GlobalKey<AnimatedListState>();
  bool _showAllSideButtons = false;
  double _showSideButtonsButtonTurns = 0;

  Future<void> _handleSearchRequest() async {
    if (topTextController.text.isEmpty) return;

    topCoordinate = await getCoordinateFromAddress(topTextController.text);

    if (topCoordinate == null) return;

    center = LatLng(topCoordinate!.latitude, topCoordinate!.longitude);
    _mapController.move(center, 18);

    if (topTextController.text.isNotEmpty) {
      topCoordinate = await getCoordinateFromAddress(topTextController.text);
      _mapController.move(center, 18);
    }
  }

  List<Polyline<Object>> routeLines = [];

  Future<void> _handleAtoBRequest() async {
    topCoordinate = await getCoordinateFromAddress(topTextController.text);
    bottomCoordinate =
        await getCoordinateFromAddress(bottomTextController.text);

    if (topCoordinate != null && bottomCoordinate != null) {
      currentJourney.route =
          await coordinatesToRoute([topCoordinate!, bottomCoordinate!], true);

      setState(() {
        routeLines = currentJourney.route!.drawRoute();
      });
    }
    /* If only one text box is filled, then center the map on the only sight. */
    if (topTextController.text.isEmpty ^ bottomTextController.text.isEmpty) {
      if (topTextController.text.isEmpty) {
        center =
            LatLng(bottomCoordinate!.latitude, bottomCoordinate!.longitude);
      } else {
        center = LatLng(topCoordinate!.latitude, topCoordinate!.longitude);
      }
      _mapController.move(center, 12);
    }
    /* If both places are entered, center the map on the average between them */
    else if (topTextController.text.isNotEmpty &&
        topTextController.text.isNotEmpty) {
      LatLngBounds bounds = LatLngBounds(
          LatLng(topCoordinate!.latitude, topCoordinate!.longitude),
          LatLng(bottomCoordinate!.latitude, bottomCoordinate!.longitude));
      center = bounds.center;
      _mapController.fitCamera(CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(70),
      ));
    }
  }

  Future<void> getNearbySights() async {
    // TODO: filter sights & store filtered list

    recommendedSights =
        await getSights(center, radiusInMiles * METERS_IN_A_MILE);

    // list of Sights for each point is stored in list predeterminedSights
    List<List<Sight>> predeterminedSights = await Future.wait(
      currentJourney.sights().map((point) => getSights(point.getCoordinate().toLatLng(), radiusInMiles * METERS_IN_A_MILE))
    );
    // transfer all sights to recommendedSights
    for(List<Sight> sights in predeterminedSights) {
      recommendedSights.addAll(sights);
    }

    //  currentJourney
    //       .setSights(await getSights(center, radiusInMiles * METERS_IN_A_MILE));
    setState(() {});
  }

  Future<LocationData?> _currentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    Location location = Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return await location.getLocation();
  }

  double radiusInMiles = STARTING_MILES_RADIUS;

  List<Sight> recommendedSights = [];

  void recommendedToSelected(int index) {
    setState(() {
      currentJourney.addSight(recommendedSights.removeAt(index));
    });
  }

  void selectedToRecommended(int index) {
    setState(() {
      recommendedSights.add(currentJourney.removeSight(index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableMenu(
        recommendedToSelected: recommendedToSelected,
        selectedToRecommended: selectedToRecommended,
        recommendedSights: recommendedSights,
        onRadiusChanged: (radiusMiles) {
          setState(() {
            radiusInMiles = radiusMiles;
          });
        },
        backgroundChild: Stack(children: [
          FutureBuilder<LocationData?>(
              future: _currentLocation(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
                if (firstBuild) {
                  if (snapchat.hasData) {
                    final LocationData currentLocation = snapchat.data;
                    center = LatLng(
                        currentLocation.latitude!, currentLocation.longitude!);
                    firstBuild = false;
                    return FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: center,
                          initialZoom: 17,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          PolylineLayer(polylines: [...routeLines]),
                        ]);
                  }
                } else {
                  return FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: center,
                        initialZoom: 17,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              borderStrokeWidth: 3,
                              color: const Color.fromARGB(50, 158, 28, 181),
                              borderColor: const Color.fromARGB(255, 106, 0, 124),
                              point: center,
                              radius: radiusInMiles * METERS_IN_A_MILE,
                              useRadiusInMeter: true,
                            ),
                          ],
                        ),
                        CircleLayer(
                          circles: currentJourney.sights().map((Sight sight) => CircleMarker(
                              borderStrokeWidth: 3,
                              color: const Color.fromARGB(50, 158, 28, 181),
                              borderColor: const Color.fromARGB(255, 106, 0, 124),
                              point: sight.getCoordinate().toLatLng(),
                              radius: radiusInMiles * METERS_IN_A_MILE,
                              useRadiusInMeter: true,
                          )).toList(),
                        ),
                        MarkerLayer(
                          markers: currentJourney.sights().map((Sight sight) => Marker(
                                  point: sight.getCoordinate().toLatLng(),
                                  child: CustomPopup(
                                      content: SizedBox(
                                          width: 200,
                                          height: 100,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(sight.name(),
                                                    textScaler: const TextScaler.linear(1.2)),
                                                const ElevatedButton(
                                                    onPressed: null,
                                                    child: Text("Open in Wikipedia")
                                                )
                                              ]
                                          )
                                      ),
                                      child: const Icon(
                                        Icons.location_pin,
                                        size: 30,
                                        color: Colors.red,
                                      )
                                  )
                          )).toList(),
                        ),
                        PolylineLayer(polylines: [...routeLines]),
                      ]);
                }
                return const Center(child: CircularProgressIndicator());
              }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(30)),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Card(
                            child: TextField(
                              onSubmitted: (value) {
                                if (_showBottomTextField) {
                                  _handleAtoBRequest();
                                } else {
                                  // TODO: handle radius-mode requests
                                  _handleSearchRequest();
                                }
                              },
                              controller: topTextController,
                              decoration: InputDecoration(
                                  hintText: _showBottomTextField
                                      ? "Start of route"
                                      : "Center of route"),
                            ),
                          ),
                        ),
                        Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          maintainSize: true,
                          visible: _showBottomTextField,
                          child: Container(
                            transformAlignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Card(
                              child: TextField(
                                onSubmitted: (value) {
                                  if (_showBottomTextField) {
                                    _handleAtoBRequest();
                                  }
                                },
                                controller: bottomTextController,
                                decoration: const InputDecoration(
                                    hintText: "Destination"),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedRotation(
                        turns: _turnsShowBottomTextFieldButton,
                        duration: const Duration(milliseconds: 400),
                        child: Card(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showBottomTextField = !_showBottomTextField;
                                  _turnsShowBottomTextFieldButton +=
                                      0.25 * (_showBottomTextField ? -1 : 1);
                                });
                              },
                              icon: const Icon(
                                  Icons.keyboard_arrow_left_outlined)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 56,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    children: [
                      Card(
                        child: IconButton(
                            onPressed: _handleShowSideButtons,
                            icon: AnimatedRotation(
                              turns: _showSideButtonsButtonTurns,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(Icons.add),
                            )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: AnimatedList(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          key: _listKey,
                          initialItemCount: 0,
                          itemBuilder: (context, index, animation) {
                            return SlideTransition(
                                position: animation.drive(Tween(
                                    begin: const Offset(3, 0),
                                    end: const Offset(0, 0))),
                                child: _sideButtons[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
