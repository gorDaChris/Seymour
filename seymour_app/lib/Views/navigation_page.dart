import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:seymour_app/Views/map_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  void navigateToMapPage() {
    Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => const MapPage()));
  }

  // TODO: SlidingUpPanel animates to different height
  // TODO: For now just make it immediately open or close
  void _showDestinationMenu() {

  }

  void _hideDestinationMenu() {

  }

  @override
  void initState() {
    super.initState();
  }

  // No clue if this will be used. Either a sanity check or animation safety
  bool _atDestination = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        isDraggable: false,
        panelSnapping: true,
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
        panel: const Text(
          "YOU'RE HERE",
          textScaler: TextScaler.linear(2)
        ),
        // These are the navigation instructions
        // TODO: Global button that calls _showDestinationMenu
        collapsed: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "IMAGE",
              textScaler: TextScaler.linear(2)
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "INSTRUCTIONS",
                  textScaler: TextScaler.linear(2)
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
    );
  }
}
