import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart'; // ✅ เพิ่ม
import '../models/quote.dart';
import '../providers/quote_provider.dart';

class QuoteCard extends StatefulWidget {
  final Quote quote;
  final bool showActions;

  const QuoteCard({Key? key, required this.quote, this.showActions = true})
      : super(key: key);

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  final translator = GoogleTranslator();
  bool isTranslated = false;
  String displayedQuote = "";
  String displayedAuthor = "";

  @override
void didUpdateWidget(covariant QuoteCard oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.quote != widget.quote) {
    setState(() {
      displayedQuote = widget.quote.quote;
      displayedAuthor = widget.quote.author;
      isTranslated = false; // รีเซ็ตการแปล
    });
  }
}

  @override
  void initState() {
    super.initState();
    displayedQuote = widget.quote.quote;
    displayedAuthor = widget.quote.author;
  }

  Future<void> _toggleTranslation() async {
    if (isTranslated) {
      // กลับเป็นต้นฉบับ
      setState(() {
        displayedQuote = widget.quote.quote;
        displayedAuthor = widget.quote.author;
        isTranslated = false;
      });
    } else {
      try {
        final translationQuote = await translator.translate(
          widget.quote.quote,
          from: 'en',
          to: 'th', // ✅ แปลเป็นภาษาไทย
        );
        final translationAuthor = await translator.translate(
          widget.quote.author,
          from: 'en',
          to: 'th',
        );
        setState(() {
          displayedQuote = translationQuote.text;
          displayedAuthor = translationAuthor.text;
          isTranslated = true;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Translation failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<QuoteProvider>(context);
    final isFav = prov.isFavorite(widget.quote);

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
                    '"$displayedQuote"',
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
                '- $displayedAuthor',
                style: TextStyle(
                  color: Colors.pink.shade400,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            if (widget.showActions) const SizedBox(height: 16),
            if (widget.showActions)
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
                        prov.removeFavorite(widget.quote);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from favorites'),
                          ),
                        );
                      } else {
                        prov.addFavorite(widget.quote);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved to favorites')),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.translate,
                        color: Colors.pink, size: 26),
                    tooltip: 'Translate',
                    onPressed: _toggleTranslation,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.pink, size: 26),
                    tooltip: 'Share',
                    onPressed: () {
                      Share.share('"${displayedQuote}" — ${displayedAuthor}');
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
