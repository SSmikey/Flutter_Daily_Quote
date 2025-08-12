// TODO Implement this library.
import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';

class QuoteProvider extends ChangeNotifier {
  Quote? current;
  List<Quote> all = [];
  List<Quote> favorites = [];
  bool loading = false;
  ThemeMode themeMode = ThemeMode.light;

  QuoteProvider() {
    _init();
  }

  Future<void> _init() async {
    loading = true;
    notifyListeners();
    await loadAllQuotes();
    await loadFavorites();
    await fetchRandom();
    loading = false;
    notifyListeners();
  }

  Future<void> loadAllQuotes() async {
    try {
      all = await ApiService.getAllQuotes(limit: 200);
    } catch (e) {
      all = [];
    }
  }

  Future<void> fetchRandom() async {
    try {
      current = await ApiService.getRandomQuote();
    } catch (e) {
      // fallback: pick one from all
      if (all.isNotEmpty) current = all.first;
    }
    notifyListeners();
  }

  Quote? quoteOfTheDay() {
    if (all.isEmpty) return current;
    final now = DateTime.now();
    final idx = (now.year + now.month + now.day) % all.length;
    return all[idx];
  }

  List<Quote> search(String keyword) {
    final q = keyword.toLowerCase().trim();
    if (q.isEmpty) return [];
    return all
        .where(
          (e) =>
              e.quote.toLowerCase().contains(q) ||
              e.author.toLowerCase().contains(q),
        )
        .toList();
  }

  Future<void> loadFavorites() async {
    favorites = await FavoritesService.loadFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(Quote q) async {
    if (favorites.any((f) => f.id == q.id)) return;
    favorites.add(q);
    await FavoritesService.saveFavorites(favorites);
    notifyListeners();
  }

  Future<void> removeFavorite(Quote q) async {
    favorites.removeWhere((f) => f.id == q.id);
    await FavoritesService.saveFavorites(favorites);
    notifyListeners();
  }

  bool isFavorite(Quote q) => favorites.any((f) => f.id == q.id);

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
