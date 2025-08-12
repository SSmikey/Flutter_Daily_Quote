import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';
import '../providers/quote_provider.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final bool showActions;

  const QuoteCard({Key? key, required this.quote, this.showActions = true})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<QuoteProvider>(context);
    final isFav = prov.isFavorite(quote);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              '"${quote.quote}"',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '- ${quote.author}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            if (showActions) const SizedBox(height: 12),
            if (showActions)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pink,
                    ),
                    onPressed: () {
                      if (isFav) {
                        prov.removeFavorite(quote);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from favorites'),
                          ),
                        );
                      } else {
                        prov.addFavorite(quote);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved to favorites')),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.pink),
                    onPressed: () {
                      Share.share('"${quote.quote}" — ${quote.author}');
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
