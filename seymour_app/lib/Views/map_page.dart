import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:seymour_app/Common/Models/coordinate.dart';
import 'package:seymour_app/Common/Models/journey.dart';
import 'package:seymour_app/Common/Queries/address_to_coordinates.dart';
import 'package:seymour_app/Common/Queries/coordinates_to_route.dart';
import 'package:seymour_app/Views/draggable_menu.dart';
import 'package:seymour_app/Views/save_page.dart';

Journey currentJourney = Journey();

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  TextEditingController topTextController = TextEditingController();
  TextEditingController bottomTextController = TextEditingController();

  Coordinate? topCoordinate;
  Coordinate? bottomCoordinate;

  double _turnsShowBottomTextFieldButton = 0;
  bool _showBottomTextField = false;

  void navigateToImportExportSavePage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SavePage()));
  }

  void _handleShowSideButtons() {
    _showAllSideButtons = !_showAllSideButtons;
    if (_showAllSideButtons) {
      setState(() {
        _showSideButtonsButtonTurns = 0.125;
      });

      _sideButtons.add(Card(
        child: IconButton(
          onPressed: () {},
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
          onPressed: () {},
          icon: const Icon(Icons.navigation),
        ),
      ));

      _listKey.currentState?.insertItem(2);
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
    }
  }

  final List<Widget> _sideButtons = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _listKey = GlobalKey<AnimatedListState>();
  bool _showAllSideButtons = false;
  double _showSideButtonsButtonTurns = 0;

  Future<void> _handleAtoBRequest() async {
    topCoordinate = await getCoordinateFromAddress(topTextController.text);
    bottomCoordinate =
        await getCoordinateFromAddress(bottomTextController.text);

    if (topCoordinate != null && bottomCoordinate != null) {
      print("Coordintes Obtained");

      currentJourney.route =
          await coordinatesToRoute([topCoordinate!, bottomCoordinate!], true);

      setState(() {
        routeLine = currentJourney.route!.drawRoute().first;
      });
    }
  }

  Polyline<Object> routeLine = Polyline(points: []);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableMenu(
          backgroundChild: Container(
        color: Colors.green,
        child: Stack(children: [
          FutureBuilder<LocationData?>(
              future: _currentLocation(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
                if (snapchat.hasData) {
                  final LocationData currentLocation = snapchat.data;
                  return FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(currentLocation.latitude!,
                            currentLocation.longitude!),
                        initialZoom: 12,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        PolylineLayer(polylines: [routeLine]),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    AnimatedRotation(
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
                            icon:
                                const Icon(Icons.keyboard_arrow_left_outlined)),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 65,
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
                        width: 65,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: AnimatedList(
                          padding: const EdgeInsets.all(5),
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
      )),
    );
  }
}
