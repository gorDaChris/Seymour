// ignore: depend_on_referenced_packages
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'package:seymour_app/Common/Models/filtered_tags.dart';
import 'package:seymour_app/Common/Models/tag.dart'; 

Future<File> get _localFile async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/tags.json');
}

Future<Map<String, Tag>> setFiltersInternal() async {
  final file = await _localFile;
  String filtersRaw = await file.readAsString();
  var jsonObject = jsonDecode(filtersRaw);

  if (jsonObject?.length == 0 || jsonObject?[0] == null) {
    return FilteredTags.tags;
  }

  int i = 0;
  for (var entry in FilteredTags.tags.entries) {
    entry.value.filtered = jsonObject[i++]["filtered"];
  }

  return FilteredTags.tags;

}