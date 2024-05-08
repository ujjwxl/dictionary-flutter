import 'dart:convert';

import 'package:dict/models/dictionary_model.dart';
import 'package:http/http.dart' as http;

class DictionaryService {
  String baseUrl = "https://api.dictionaryapi.dev/api/v2/entries/en/";

  Future<DictionaryModel> getMeaning(String word) async {
    Uri url = Uri.parse("$baseUrl$word");
    final response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DictionaryModel.fromJson(data[0]);
      } else {
        throw Exception('Failed to load the meaning');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to load the meaning');
    }
  }
}
