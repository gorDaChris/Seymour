import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seymour_app/Common/Models/filtered_tags.dart';
import 'package:seymour_app/Common/Models/tag.dart';
import 'package:seymour_app/Common/Queries/get_filters.dart';

// DEV
// import 'dart:developer';


class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<Tag> tags = FilteredTags.tags.values.toList();
  //List<bool?> checkedItems = List<bool?>.generate(33, (index) => false);


  Future<void> _saveCheckedItems() async {
    try {
      final file = await _localFile;
      String jsonStr = jsonEncode(tags);
      await file.writeAsString(jsonStr);
      setFiltersInternal();
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
      appBar: AppBar(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(tags[index].displayName),
            value: tags[index].filtered,
            onChanged: (bool? value) {
              setState(() {
                tags[index].filtered = value!;
              });
            },
          );
        },
        itemCount: tags.length
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           _saveCheckedItems().then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Successfully saved changes.'),
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
        child: const Icon(Icons.save),
      ),
    );
  }
}
