import 'dart:convert';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart';

void readWikipediaArticleAloud(String articleName) async {
  articleName = articleName.substring(3);
  print(articleName);

  Response response = await get(Uri.https("en.wikipedia.org", "/w/api.php", {
    "action": "query",
    "format": "json",
    "prop": "extracts",
    "titles": articleName,
    "formatversion": "2",
    "exsentences": "10",
    "exlimit": "1",
    // "exintro": "1",
    "explaintext": "1"
  }));

  var jsonObject = jsonDecode(response.body);
  print(jsonObject);

  String textToRead = jsonObject["query"]["pages"][0]["extract"];
  print(textToRead);
  textToRead = textToRead.replaceAll("\n", "");

  FlutterTts flutterTts = FlutterTts();

  print(textToRead);

  await flutterTts.speak("Hello World!");
  flutterTts.speak(textToRead);
}
