// ignore: depend_on_referenced_packages
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:developer';

import 'package:seymour_app/Common/Models/filtered_tags.dart';
import 'package:seymour_app/Common/Models/tag.dart'; // for log()

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

  log("Before: ");
  log(FilteredTags.tags.entries.toString());

  int i = 0;
  for (var entry in FilteredTags.tags.entries) {
    entry.value.filtered = jsonObject[i++]["filtered"];
  }

  log("After: ");
  log(FilteredTags.tags.entries.toString());

  return FilteredTags.tags;

  /*
  final file = await _localFile;
  String filtersRaw = await file.readAsString();
  String stringFilters = filtersRaw.substring(1, filtersRaw.length-1);
  List<String> fsplit = stringFilters.split(',');

  log(fsplit.toString());

  List<bool> filters = [];
  for (String s in fsplit) {
    filters.add(s == "true");
  }

  log(filters.toString());

  int i = 0;
  for (var value in FilteredTags.tags.values) {
    value.filtered = filters[i++];
  }

  log(filters.toString());
  */

}