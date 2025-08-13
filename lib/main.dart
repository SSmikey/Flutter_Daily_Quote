import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/quote_provider.dart';
import 'pages/home_page.dart';
import 'pages/categories_page.dart';
import 'pages/favorites_page.dart';
import 'package:your_project/widgets/sound_button.dart';


void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => QuoteProvider(),
    child: const QuoteApp(),
  ));
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({Key? key}) : super(key: key);

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.pink,
      scaffoldBackgroundColor: const Color(0xFFFFF5F8),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.pink,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black, foregroundColor: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<QuoteProvider>(context);
    return MaterialApp(
      title: 'Quote App',
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: prov.themeMode,
      routes: {
        '/': (_) => const HomePage(),
        '/categories': (_) => const CategoriesPage(),
        '/favorites': (_) => const FavoritesPage(),
      },
      initialRoute: '/',
    );
  }
}
