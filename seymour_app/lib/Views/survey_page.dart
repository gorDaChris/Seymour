import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SurveyPage(),
    );
  }
}

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<bool?> checkedItems = List<bool?>.generate(15, (index) => false);
  List<String> tags = [
    'Sculpture',
    'Statue',
    'Mural',
    'Graffiti',
    'Installation',
    'Bust',
    'Stone',
    'Painting',
    'Architecture',
    'Mosaic',
    'Relief',
    'Fountain',
    'Street Art',
    'Azulejo',
    'Land Art',
  ];

  Future<void> _saveCheckedItems() async {
    try {
      final file = await _localFile;
      String jsonStr = jsonEncode(checkedItems);
      await file.writeAsString(jsonStr);
    } catch (e) {
      print('Error saving tags: $e');
    }
  }
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/tags.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(tags[index]),
            value: checkedItems[index],
            onChanged: (bool? value) {
              setState(() {
                checkedItems[index] = value;
              });
            },
          );
        },
        itemCount: tags.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           _saveCheckedItems().then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tags saved to JSON file.'),
              ),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to save checked items: $error'),
              ),
            );
          });
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
