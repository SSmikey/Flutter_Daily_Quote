import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/quote_provider.dart';
import 'pages/home_page.dart';
import 'pages/categories_page.dart';
import 'pages/favorites_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => QuoteProvider(),
      child: const QuoteApp(),
    ),
  );
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({Key? key}) : super(key: key);

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.pink,
      scaffoldBackgroundColor: const Color(0xFFFFF5F8),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18))),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.pink,
      scaffoldBackgroundColor: const Color(0xFF18181A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF23232B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF23232B),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18))),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF23232B),
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<QuoteProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quote App',
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: prov.themeMode,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [
    HomePage(),
    CategoriesPage(),
    FavoritesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
