import 'dart:convert';

import 'package:google_maps/features/maps/data/models/search_model/search_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SebhaSharedPrefs {
  static const _k1 = 'history';

  static Future<void> save(List<SearchModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_k1, jsonList);
  }

  static Future<List<SearchModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_k1) ?? [];

    return list.map((e) => SearchModel.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_k1);
  }
}
