// ignore: depend_on_referenced_packages
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:developer'; // for log()

Future<File> get _localFile async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/tags.json');
}

Future<List<bool>> getFilters() async {
  final file = await _localFile;
  String filtersRaw = await file.readAsString();
  String stringFilters = filtersRaw.substring(1, filtersRaw.length-2);
  List<String> fsplit = stringFilters.split(',');

  log(fsplit.toString());

  List<bool> filters = [];
  for (String s in fsplit) {
    filters.add(s == "true");
  }

  log(filters.toString());

  return filters;
}