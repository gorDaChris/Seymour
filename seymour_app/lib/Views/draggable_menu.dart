import 'package:flutter/material.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class DraggableMenu extends StatefulWidget {
  const DraggableMenu(
      {super.key, required this.backgroundChild, this.onRadiusChanged});

  final Widget backgroundChild;

  final void Function(double)? onRadiusChanged;

  @override
  State<DraggableMenu> createState() => _DraggableMenuState();
}

class _DraggableMenuState extends State<DraggableMenu> {
  double radius = 0.5; //TODO: talk about whether we should use diameter instead

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      panelSnapping: false,
      minHeight: 20,
      // maxHeight: MediaQuery.of(context).size.height * 0.8,
      header: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 20,
        child: const Card(
          color: Colors.grey,
        ),
      ),
      body: widget.backgroundChild,

      //This ListView may have to be changed to ListView.builder when it eventually displays locations
      panel: ListView(
        children: [
          ElevatedButton(
            child: const Text("Adjust Filters"),
            onPressed: () {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 5,
                child: Slider(
                  min: 0.1,
                  max: 2,
                  value: radius,
                  onChanged: (value) {
                    if (widget.onRadiusChanged is void Function(double)) {
                      widget.onRadiusChanged!(value);
                    }
                    setState(() {
                      radius = value;
                    });
                  },
                  label: radius.toString(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "${(radius * 10).round() / 10} mi",
                  textScaler: const TextScaler.linear(1.3),
                ),
              ) //Round to 1 decimal place
            ],
          ),
          const Divider(),
          const Text("Selected Sights"),
          const Divider(),
          const Text("Recommended Sights")
        ],
      ),
    );
  }
}
