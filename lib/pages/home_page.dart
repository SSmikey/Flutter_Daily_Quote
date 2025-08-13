import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../widgets/quote_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _topBox(BuildContext c, QuoteProvider prov) {
    final qotd = prov.quoteOfTheDay();
    final currentQuote = prov.current;
    if (currentQuote == null) return const SizedBox();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade200, Colors.pink.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.wb_sunny, color: Colors.pink, size: 22),
              SizedBox(width: 8),
              Text('Quote of the Day',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          if (qotd != null) QuoteCard(quote: qotd, showActions: true),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<QuoteProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Quote App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => prov.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: prov.loading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _topBox(context, prov),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => prov.fetchRandom(),
                            icon: const Icon(Icons.casino),
                            label: const Text('Random Quote'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.search,
                              color: Colors.pink, size: 28),
                          onPressed: () => showSearch(
                              context: context, delegate: QuoteSearch()),
                          tooltip: 'Search',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (prov.current != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: QuoteCard(quote: prov.current!, showActions: true),
                    ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
    );
  }
}

/// Search delegate (modern style)
class QuoteSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    final prov = Provider.of<QuoteProvider>(context, listen: false);
    final results = prov.search(query);
    if (results.isEmpty) {
      return const Center(
          child: Text('No results found', style: TextStyle(fontSize: 18)));
    }
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
