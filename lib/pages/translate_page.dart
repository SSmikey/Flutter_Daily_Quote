import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TranslatePage extends StatefulWidget {
  final String originalQuote;
  const TranslatePage({super.key, required this.originalQuote});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  String selectedLang = "th"; // ค่าเริ่มต้น = ไทย
  String translatedText = "";
  bool isLoading = false;

  Future<void> translateQuote() async {
    setState(() => isLoading = true);

    try {
      final res = await http.post(
        Uri.parse("https://libretranslate.com/translate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "q": widget.originalQuote,
          "source": "en",
          "target": selectedLang,
          "format": "text"
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          translatedText = data["translatedText"];
        });
      } else {
        setState(() {
          translatedText = "แปลไม่สำเร็จ (${res.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        translatedText = "เกิดข้อผิดพลาด: $e";
      });
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Translate Quote"),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Original: ${widget.originalQuote}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedLang,
              items: const [
                DropdownMenuItem(value: "th", child: Text("ไทย")),
                DropdownMenuItem(value: "en", child: Text("English")),
                DropdownMenuItem(value: "ja", child: Text("日本語")),
                DropdownMenuItem(value: "fr", child: Text("Français")),
              ],
              onChanged: (value) {
                setState(() => selectedLang = value!);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
              onPressed: translateQuote,
              icon: const Icon(Icons.g_translate, color: Colors.white),
              label: const Text("Translate",
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.pink))
                : Text(
                    translatedText,
                    style: TextStyle(
                        fontSize: 18, color: Colors.pink[900]),
                  ),
          ],
        ),
      ),
    );
  }
}
