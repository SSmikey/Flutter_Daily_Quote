import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class ApiService {
  static const String base = 'https://dummyjson.com/quotes';

  /// Get random quote endpoint
  static Future<Quote> getRandomQuote() async {
    final res = await http.get(Uri.parse('$base/random'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return Quote.fromJson(data);
    } else {
      throw Exception('Failed to fetch random quote');
    }
  }

  /// Get many quotes (for search / category building or quote of the day)
  static Future<List<Quote>> getAllQuotes({int limit = 150}) async {
    // dummyjson supports /quotes?limit=...
    final res = await http.get(Uri.parse('$base?limit=$limit'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List items = data['quotes'] ?? [];
      return items.map((e) => Quote.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch quotes list');
    }
  }

  /// Search locally (we'll search client-side using loaded list)
}
