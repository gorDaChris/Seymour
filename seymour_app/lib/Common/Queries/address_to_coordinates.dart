import 'dart:convert';

import 'package:http/http.dart';
import 'package:seymour_app/Common/Models/coordinate.dart';

//returns null if there is no place in Open Street Maps with the address
Future<Coordinate?> getCoordinateFromAddress(String address) async {
  Response response = await get(Uri.https("nominatim.openstreetmap.org",
      "search", {"q": address, "format": "json"}));

  var jsonObject = jsonDecode(response.body);

  if (jsonObject?.length == 0 || jsonObject?[0] == null) {
    return null;
  }

  return Coordinate(
      double.parse(jsonObject[0]["lat"]), double.parse(jsonObject[0]["lon"]));
}
