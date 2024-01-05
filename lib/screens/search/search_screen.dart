import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/drawer/filters_drawer.dart';
import 'package:flutter_news_app/services/firestore_service.dart';

import 'package:flutter_news_app/screens/search/article_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('News App'),
        ),
        drawer: FiltersDrawer(
          selectedCategories: _selectedCategories,
          onSelectedCategoriesChanged: (newCategory) {
            setState(() {
              _selectedCategories.contains(newCategory)
                  ? _selectedCategories.remove(newCategory)
                  : _selectedCategories.add(newCategory);
            });
          },
        ),
        body: const Text("Hello World")
        // body: ArticleListBuilder(
        //   query: FirestoreService().getArticles([]),
        // ),
        );
  }
}
