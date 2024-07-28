import 'dart:convert';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart';

Future<void> readWikipediaArticleAloud(String articleNameWithPrefix) async {
  var articleName = articleNameWithPrefix.substring(3);
  String textToRead = await getArticleText(articleName);

  FlutterTts flutterTts = FlutterTts();

  print(textToRead);

  flutterTts.speak(textToRead);
}

Future<String> getArticleText(String articleName) async {
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
  textToRead = textToRead.replaceAll("\n", " ");
  textToRead = textToRead.replaceAll("==", "");
  return textToRead;
}
