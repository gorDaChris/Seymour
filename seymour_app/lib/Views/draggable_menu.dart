import 'package:flutter/material.dart';

import 'package:seymour_app/Common/Models/sight.dart';
import 'package:seymour_app/Views/map_page.dart';
import 'package:seymour_app/Views/survey_page.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class DraggableMenu extends StatefulWidget {
  const DraggableMenu(
      {super.key,
      required this.backgroundChild,
      this.onRadiusChanged,
      required this.recommendedSights,
      required this.recommendedToSelected,
      required this.selectedToRecommended,
      required this.getNearbySights});

  final Widget backgroundChild;

  final void Function(double)? onRadiusChanged;

  final List<Sight> recommendedSights;

  final void Function(int) recommendedToSelected;
  final void Function(int) selectedToRecommended;
  final Future<void> Function() getNearbySights;

  @override
  State<DraggableMenu> createState() => _DraggableMenuState();
}

class _DraggableMenuState extends State<DraggableMenu> {
  double radius = 0.5;

  void navigateToSurveyPage(Future<void> Function() getNearbySights) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SurveyPage(
          getNearbySights: getNearbySights
        )));
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry br = const BorderRadius.only(
      topLeft: Radius.circular(15.0),
      topRight: Radius.circular(15.0),
    );
    return SlidingUpPanel(
      borderRadius: br,
      panelSnapping: false,
      minHeight: 50,
      body: widget.backgroundChild,

      //This ListView may have to be changed to ListView.builder when it eventually displays locations
      panel: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            height: 13,
            child: const Card(
              color: Colors.grey,
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(
            child: const Text("Adjust Filters"),
            onPressed: () {
              navigateToSurveyPage(widget.getNearbySights);
            },
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
          if (currentJourney.sights().isEmpty) ...[
            const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("No sights selected"),
                    ]
                )
            )
          ] else ...[
            Expanded(
                child: ListView.builder(
                itemCount: currentJourney.sights().length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(currentJourney.sights()[index].name()),
                    onTap: () {
                      widget.selectedToRecommended(index);
                    },
                  );
                },
              )
            ),
          ],
          const Divider(),
          const Text("Recommended Sights"),
          if (widget.recommendedSights.isEmpty) ...[
            const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("No nearby sights"),
                    ]
                )
            )
          ] else ...[
            Expanded(
                child: ListView.builder(
                itemCount: widget.recommendedSights.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.recommendedSights[index].name()),
                    onTap: () {
                      widget.recommendedToSelected(index);
                    },
                  );
                },
              )
            ),
          ],
        ],
      ),
    );
  }
}
