import 'package:flutter/material.dart';
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
    Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => const MapPage()));
  }

  void _toggleDestinationMenu() {
    if (_pc.isPanelOpen) {
      _pc.close();
    }
    else {
      _pc.open();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        isDraggable: false,
        panelSnapping: true,
        controller: _pc,
        body: Container(
          color: Colors.green,
          child: const Text(
            "MAP",
            textScaler: TextScaler.linear(20)
          )
        ),
        // This is the "arrived at destination" screen
        // TODO: What are we even going to do for this?
        // TODO: Button that calls _hideDestinationMenu
        // TODO: Darkened background
        panel: Container(
          color: Colors.grey,
          child: Column(
            children: <Widget>[
              const Text(
                "YOU'RE HERE",
                textScaler: TextScaler.linear(2)
              ),
              ElevatedButton(
                child: const Text(
                  "Raise/lower demo"
                ),
                onPressed: () {
                  _toggleDestinationMenu();
                }
              )
            ]
          )
        ),
        // These are the navigation instructions
        // TODO: Global button that calls _showDestinationMenu
        collapsed: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "IMAGE"
              ),
              Column(
                children: <Widget>[
                  Text(
                    "100ft - Turn left",
                    textScaler: TextScaler.linear(2)
                  ),
                  Text(
                  "Example Dr.",
                    textScaler: TextScaler.linear(1.5)
                  )
                ]
              ),
              Column(
                children: <Widget>[
                  ElevatedButton(
                    child: const Text(
                      "Raise/lower demo"
                    ),
                    onPressed: () {
                      _toggleDestinationMenu();
                    }
                  ),
                  ElevatedButton(
                    child: const Text(
                      "Go back"
                    ),
                    onPressed: () {
                      navigateToMapPage();
                    }
                  )
                ]
              )
            ]
          )
        )
      )
    );
  }
}
