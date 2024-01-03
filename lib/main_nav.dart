import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/favorites/favorites.dart';
import 'package:flutter_news_app/screens/search/search.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedBottomNavigationIndex = 0;

  final _bottomNavigationItems = [
    _BottomNavigationItem('Search', Icons.search, const SearchScreen()),
    _BottomNavigationItem('Favorites', Icons.bookmark, const FavoritesScreen()),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedBottomNavigationIndex,
          items: _bottomNavigationItems,
          onTap: (newIndex) {
            setState(() {
              _selectedBottomNavigationIndex = newIndex;
            });
          },
        ),
        body: IndexedStack(
          index: _selectedBottomNavigationIndex,
          children: _bottomNavigationItems.map((item) => item.widget).toList(),
        ),
      );
}

class _BottomNavigationItem extends BottomNavigationBarItem {
  _BottomNavigationItem(String label, IconData iconData, this.widget)
      : super(
          label: label,
          icon: Icon(iconData),
        );

  final Widget widget;
}
