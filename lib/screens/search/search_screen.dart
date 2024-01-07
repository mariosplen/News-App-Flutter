import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/drawer/filters_drawer.dart';
import 'package:flutter_news_app/navigation/bottom_navbar.dart';
import 'package:flutter_news_app/services/firestore_service.dart';

import 'package:flutter_news_app/screens/search/article_list.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.onNewTabSelected});

  final Function onNewTabSelected;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> _selectedCategories = [];
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // print all the theme colors

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      appBar: EasySearchBar(
        elevation: 2,
        showClearSearchIcon: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
          size: 28,
        ),
        searchBackIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
          size: 28,
        ),
        onSearch: (val) {
          if (val.trim() != _searchQuery) {
            setState(() {
              _searchQuery = val.trim();
              _selectedCategories.clear();
            });
          }
        },
        animationDuration: const Duration(milliseconds: 220),
        backgroundColor: Theme.of(context).colorScheme.surface,
        searchTextKeyboardType: TextInputType.name,
        searchCursorColor: Theme.of(context).colorScheme.surfaceTint,
        title: Padding(
          padding: const EdgeInsets.only(right: 19),
          child: Text(
            'News App',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: GoogleFonts.texturina().fontFamily,
              fontSize: 28,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        selected: 0,
        onTap: widget.onNewTabSelected,
      ),
      drawer: FutureBuilder(
        future:
            FirestoreService().getUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FiltersDrawer(
              selectedCategories: _selectedCategories,
              onSelectedCategoriesChanged: _onTappedNewCategory,
              onSignOut: FirebaseAuth.instance.signOut,
              name: snapshot.data!.name,
              email: snapshot.data!.email,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: ArticleListBuilder(
        query:
            FirestoreService().getArticles(_selectedCategories, _searchQuery),
      ),
    );
  }

  _onTappedNewCategory(newCategory) {
    setState(() {
      _selectedCategories.contains(newCategory)
          ? _selectedCategories.remove(newCategory)
          : _selectedCategories.add(newCategory);
    });
  }
}
