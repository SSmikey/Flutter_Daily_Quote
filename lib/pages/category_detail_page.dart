import 'package:flutter/material.dart';
import 'translate_page.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryName;
  final List<String> quotes; // รับ list ของ quotes ตามหมวด

  const CategoryDetailPage({
    super.key,
    required this.categoryName,
    required this.quotes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.pink,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final quote = quotes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TranslatePage(
                              originalQuote: quote,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.translate, color: Colors.white),
                      label: const Text(
                        "Translate",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
