import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:convert';

import 'constants.dart';
import 'model/station.dart';

class RadioController {}

Future<List> loadStations() async {
  final uri = Uri.parse(kCVSUrl);
  final response = await http
      .get(uri, headers: {"Content-Type": "application/json; charset=utf-8"});
  final body = utf8.decode(response.bodyBytes);
  List<List<dynamic>> rows = const CsvToListConverter().convert(body);

  final res = rows
      // id, url, image, genre, title
      .map((e) => Station(title: e[4], url: e[1], gerne: e[3], imgurl: e[2]))
      .toList();
  res.removeAt(0);
  return res;
}
