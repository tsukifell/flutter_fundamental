import 'dart:convert';

import 'package:bloc_api/data/model/game.dart';
import 'package:d_method/d_method.dart';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = 'https://www.freetogame.com/api/games';

  static Future<List<Game>> getLiveGames() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      DMethod.logResponse(response);
      if (response.statusCode == 200) {
        List list = jsonDecode(response.body);
        final gameData = list.map((e) => Game.fromJson(Map.from(e))).toList();
        return gameData;
      } else {
        throw 'Failed to load the data!';
      }
    } catch (exception) {
      throw exception.toString();
    }
  }
}
