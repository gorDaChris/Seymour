import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:seymour_app/Common/Models/journey.dart';
import 'package:seymour_app/Common/Queries/get_filters.dart';
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
  // TODO: list of Row Widgets
  List<File> items = [];
  final TextEditingController _textController = TextEditingController();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<List<File>> get _localJourneyFiles async {
    final path = await _localPath;
    return Directory('$path/journeys/').listSync().whereType<File>().toList();
  }

  // TODO: click row widget to expand options

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
              onPressed: () async {
                String path = await _localPath;
                File("$path/journeys/${_textController.text}.json")
                    .writeAsString(jsonEncode(currentJourney.toJson()));

                setState(() {
                  // items.add(_textController.text);
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
        body: FutureBuilder<List<File>>(
            future: _localJourneyFiles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    if (snapshot.data!.isEmpty) ...[
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
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Text(
                                snapshot.data![index].path
                                    .split("/")
                                    .last
                                    .replaceFirst(".json", ""),
                                textScaler: TextScaler.linear(1.5),
                              ),
                              trailing: SizedBox(
                                width: 225,
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          currentJourney = Journey.fromJson(
                                              jsonDecode(snapshot.data![index]
                                                  .readAsStringSync()));
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(Icons.file_open)),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await Share.shareXFiles([XFile(snapshot.data![index].path)]);
                                        },
                                        child: Icon(Icons.ios_share)),
                                    ElevatedButton(
                                        onPressed: () {
                                          snapshot.data![index].deleteSync();
                                          setState(() {});
                                        },
                                        child: Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
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
