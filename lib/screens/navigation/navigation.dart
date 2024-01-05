import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/favorites/favorites.dart';

import 'package:flutter_news_app/screens/navigation/bottom_nav_item_widget.dart';
import 'package:flutter_news_app/screens/search/search_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedBottomNavigationIndex = 0;

  final _bottomNavigationItems = [
    BottomNavigationItemWidget('Search', Icons.search, const SearchScreen()),
    BottomNavigationItemWidget(
        'Favorites', Icons.bookmark, const FavoritesScreen()),
  ];

  void _onTap(newIndex) {
    setState(() {
      _selectedBottomNavigationIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedBottomNavigationIndex,
          items: _bottomNavigationItems,
          onTap: _onTap,
        ),
        body: IndexedStack(
          index: _selectedBottomNavigationIndex,
          children: _bottomNavigationItems.map((item) => item.widget).toList(),
        ),
      );
}
