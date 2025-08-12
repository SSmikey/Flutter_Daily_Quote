import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../widgets/quote_card.dart';
import '../models/quote.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  static const List<String> cats = ['Motivation', 'Love', 'Work', 'Life'];

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<QuoteProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      appBar: AppBar(title: const Text('Category')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final c in cats)
            ElevatedButton(
              onPressed: () {
                final list = _filterByCategory(prov.all, c);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CategoryResultPage(title: c, list: list)),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: c == 'Motivation' ? Colors.pink : const Color(0xFFFFC1CC)),
              child: Padding(padding: const EdgeInsets.all(14), child: Text(c)),
            ),
        ],
      ),
    );
  }

  /// Simple heuristic: choose quotes containing keywords (client-side)
  List<Quote> _filterByCategory(List<Quote> all, String cat) {
    final k = cat.toLowerCase();
    return all.where((q) => q.quote.toLowerCase().contains(k) || q.author.toLowerCase().contains(k)).toList();
  }
}

class CategoryResultPage extends StatelessWidget {
  final String title;
  final List list;
  const CategoryResultPage({Key? key, required this.title, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quotes = List.from(list);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        children: quotes.map((q) => QuoteCard(quote: q)).toList(),
      ),
    );
  }
}
