import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../widgets/quote_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<QuoteProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      appBar: AppBar(title: const Text('My Favorites')),
      body: prov.favorites.isEmpty
          ? Center(child: Text('No favorites yet. Tap ❤ to save a quote!', style: TextStyle(color: Colors.grey[700])))
          : ListView(
              children: prov.favorites.map((q) => QuoteCard(quote: q)).toList(),
            ),
    );
  }
}
