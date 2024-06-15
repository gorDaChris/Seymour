import 'package:flutter/material.dart';
import 'package:seymour_app/Views/draggable_menu.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  TextEditingController topTextController = TextEditingController();
  TextEditingController bottomTextController = TextEditingController();

  double _turnsShowBottomTextFieldButton = 0;

  bool _showBottomTextField = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableMenu(
          backgroundChild: Container(
        color: Colors.green,
        child: Stack(children: [
          const Text(
            "MAP",
            textScaler: TextScaler.linear(20),
          ),
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
                              controller: topTextController,
                              decoration: InputDecoration(
                                  hintText: _showBottomTextField
                                      ? "Start of route"
                                      : "Center of route"),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _showBottomTextField,
                          child: Container(
                            transformAlignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Card(
                              child: TextField(
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
            ],
          ),
        ]),
      )),
    );
  }
}
