import 'package:choice/choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/drawer/filters_drawer.dart';
import 'package:flutter_news_app/navigation/bottom_navbar.dart';
import 'package:flutter_news_app/services/firestore_service.dart';

import 'package:flutter_news_app/screens/search/article_list.dart';
import 'package:flutter_news_app/widgets/search_appbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.onNewTabSelected});

  final Function onNewTabSelected;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _selectedCategory;
  String _searchQuery = '';

  final List<ChoiceType> sortChoices = [
    ChoiceType('Latest', 'publishedAt'),
    ChoiceType('Most Popular', 'popularity'),
    ChoiceType('Top Matches', 'relevancy'),
  ];
  String _selectedSortBy = 'publishedAt';

  void _setNewCategories(newCategory) {
    setState(() {
      _selectedCategory = newCategory;
    });
  }

  void _setNewSortBy(String? value) {
    setState(() => _selectedSortBy = value!);
  }

  void _setNewSearchQuery(String value) {
    if (value.trim() != _searchQuery) {
      setState(() {
        _searchQuery = value.trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      appBar: SearchTopBar(
        onSearch: _setNewSearchQuery,
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
              selectedCategory: _selectedCategory,
              onSelectedCategoriesChanged: _setNewCategories,
              onSignOut: FirebaseAuth.instance.signOut,
              name: snapshot.data!.name,
              imageUrl: snapshot.data!.avatarUrl,
              email: snapshot.data!.email,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: Column(
        children: [
          _selectedCategory == null
              ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Choice<String>.inline(
                    clearable: false,
                    value: ChoiceSingle.value(_selectedSortBy),
                    onChanged: ChoiceSingle.onChanged(_setNewSortBy),
                    itemCount: sortChoices.length,
                    itemBuilder: (state, i) {
                      final choice = sortChoices[i];
                      return ChoiceChip(
                        selected: state.selected(choice.value),
                        onSelected: state.onSelected(choice.value),
                        label: Text(choice.title),
                      );
                    },
                    listBuilder: ChoiceList.createScrollable(
                      spacing: 10,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: ArticleListBuilder(
              loadedArticles: [],
              selectedCategory: _selectedCategory,
              searchQuery: _searchQuery,
              selectedSortBy: _selectedSortBy,
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceType {
  final String title;
  final String value;
  const ChoiceType(this.title, this.value);
}
