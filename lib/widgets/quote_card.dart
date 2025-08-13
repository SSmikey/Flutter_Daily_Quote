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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade50, Colors.white],
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.format_quote, color: Colors.pink, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '"${quote.quote}"',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '- ${quote.author}',
                style: TextStyle(
                  color: Colors.pink.shade400,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            if (showActions) const SizedBox(height: 16),
            if (showActions)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pink,
                      size: 28,
                    ),
                    tooltip:
                        isFav ? 'Remove from favorites' : 'Add to favorites',
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
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.pink, size: 26),
                    tooltip: 'Share',
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
