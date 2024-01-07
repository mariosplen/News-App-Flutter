import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    super.key,
    required this.selected,
    required this.onTap,
  });
  final int selected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: const Color.fromARGB(255, 141, 63, 138),
      currentIndex: selected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.article_rounded),
          label: 'Articles',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_rounded),
          label: 'Favorites',
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      onTap: (index) {
        onTap(index);
      },
    );
  }
}
