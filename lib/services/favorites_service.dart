import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';

class FavoritesService {
  static const String key = 'favorites_quotes';

  static Future<List<Quote>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    if (str == null) return [];
    final List decoded = json.decode(str);
    return decoded.map((e) => Quote.fromJson(e)).toList();
  }

  static Future<void> saveFavorites(List<Quote> list) async {
    final prefs = await SharedPreferences.getInstance();
    final str = json.encode(list.map((q) => q.toJson()).toList());
    await prefs.setString(key, str);
  }
}