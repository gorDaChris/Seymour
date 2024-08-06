import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:seymour_app/Views/map_page.dart';

/*
 * The generic layout of this page was generated with the assistance of GPT-4 and has since been modified.
 *
 * The following prompt was used:
 * "I am designing a page to save items using flutter. I want a button at the bottom left to "save"
 * placeholder items, so that when it is clicked, a keyboard will appear and after selecting confirm,
 * a new row with the entered name will appear. There will also be a button on the bottom right, that
 * does not have to do anything at the moment. Can you generate a dart file that will get me this page?"
 */

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  List items = [];

  @override
  void initState() {
    super.initState();
    _listJourneyFiles();
  }

  // TODO: list of row widgets
  final TextEditingController _textController = TextEditingController();
  String title = '';

  // TODO: click row widget to expand options

  // TODO: Verify that this is working
  // TODO: System popup with load export delete
  // TODO: Review the toJson code in other areas. Implement here as well
  void _listJourneyFiles() async {
    final path = await _localPath;

    if (!(await Directory("$path/journeys/").exists())) {
      await Directory("$path/journeys/").create();
    }
    items = Directory("$path/journeys/").listSync();
  }

  // TODO: Check if file exists and introduct extra popup if true
  void _saveJourney() async {
    try {
      final file = await _localFile;
      String jsonStr = jsonEncode(currentJourney.toJson());
      await file.writeAsString(jsonStr);
      print("Saved journey: $jsonStr");
    }
    catch (e) {
      print('Error saving journey: $e');
    }
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/journeys/${_textController.text}.json');
  }

  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Save current journey as..."),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: "Journey name"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                _textController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () {
                setState(() {
                  _saveJourney();
                  _listJourneyFiles();
                });
                _textController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            if (items.isEmpty) ...[
              // TODO completely center text
              const Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Text("Looks like you haven't saved anything yet."),
                  ]))
            ] else ...[
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index].path),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    // SAVE AS button
                    height: 75,
                    child: ElevatedButton(
                      onPressed: _showInputDialog,
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                      child: const Text("SAVE AS"),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    // IMPORT button
                    height: 75,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      onPressed: () {},
                      child: const Text("IMPORT"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
