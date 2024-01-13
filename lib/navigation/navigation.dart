import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/favorites/favorites.dart';
import 'package:flutter_news_app/screens/search/search_screen.dart';
// import 'package:flutter_news_app/test_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedBottomNavigationIndex = 0;

  void onNewIndex(int index) {
    setState(() {
      _selectedBottomNavigationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screens = [
      // TestScreen(),
      SearchScreen(onNewTabSelected: onNewIndex),
      ProfileScreen(onNewTabSelected: onNewIndex),
    ];
    return screens[_selectedBottomNavigationIndex];
  }
}
