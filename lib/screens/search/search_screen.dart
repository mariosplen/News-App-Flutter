import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/drawer/filters_drawer.dart';
import 'package:flutter_news_app/screens/navigation/bottom_navbar.dart';
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

  @override
  Widget build(BuildContext context) {
    // print all the theme colors

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      appBar: AppBar(
        title: Text(
          'News App',
          style: TextStyle(
            fontFamily: GoogleFonts.texturina().fontFamily,
            fontSize: 28,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Theme.of(context).colorScheme.onSurface,
            height: 1.0,
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
        query: FirestoreService().getArticles(_selectedCategories),
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
