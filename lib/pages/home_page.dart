import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../widgets/quote_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _topBox(BuildContext c, QuoteProvider prov) {
    final qotd = prov.quoteOfTheDay();
    return Column(
      children: [
        const SizedBox(height: 20),
        Text('Quote of the Day', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        if (qotd != null) QuoteCard(quote: qotd, showActions: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<QuoteProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      appBar: AppBar(
        title: const Text('Quote App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => prov.toggleTheme(),
          ),
        ],
      ),
      body: prov.loading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _topBox(context, prov),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => prov.fetchRandom(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                    child: const Text('Random Quote'),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/categories'),
                          icon: const Icon(Icons.category),
                          label: const Text('Category'),
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFC1CC)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => showSearch(context: context, delegate: QuoteSearch()),
                          icon: const Icon(Icons.search),
                          label: const Text('Search'),
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFC1CC)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (prov.current != null) QuoteCard(quote: prov.current!, showActions: true),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) Navigator.pushNamed(context, '/favorites');
        },
        selectedItemColor: Colors.pink,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Favorites'),
        ],
      ),
    );
  }
}

/// Search delegate
class QuoteSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    final prov = Provider.of<QuoteProvider>(context, listen: false);
    final results = prov.search(query);
    return ListView(
      children: results.map((q) => QuoteCard(quote: q)).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text('Type keywords or author name...'),
    );
  }
}
