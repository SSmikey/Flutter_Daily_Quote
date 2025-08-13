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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Categories',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        children: [
          for (final c in cats)
            Container(
              margin: const EdgeInsets.only(bottom: 18),
              child: ElevatedButton.icon(
                onPressed: () {
                  final list = _filterByCategory(prov.all, c);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            CategoryResultPage(title: c, list: list)),
                  );
                },
                icon: Icon(
                  c == 'Motivation'
                      ? Icons.flash_on
                      : c == 'Love'
                          ? Icons.favorite
                          : c == 'Work'
                              ? Icons.work
                              : Icons.emoji_emotions,
                  color: Colors.pink,
                ),
                label: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  child: Text(
                    c,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      c == 'Motivation' ? Colors.pink : const Color(0xFFFFC1CC),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Simple heuristic: choose quotes containing keywords (client-side)
  List<Quote> _filterByCategory(List<Quote> all, String cat) {
    final k = cat.toLowerCase();
    return all
        .where((q) =>
            q.quote.toLowerCase().contains(k) ||
            q.author.toLowerCase().contains(k))
        .toList();
  }
}

class CategoryResultPage extends StatelessWidget {
  final String title;
  final List list;
  const CategoryResultPage({Key? key, required this.title, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quotes = List.from(list);
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: quotes.isEmpty
          ? const Center(child: Text('No quotes found in this category'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: quotes.length,
              itemBuilder: (context, i) => QuoteCard(quote: quotes[i]),
            ),
    );
  }
}
