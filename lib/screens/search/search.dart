import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:news_api_flutter_package/model/article.dart';

import 'package:flutter_news_app/models/filters.dart';
import 'package:flutter_news_app/screens/search/article_list_item.dart';
import 'package:flutter_news_app/screens/search/search_top_bar.dart';
import 'package:flutter_news_app/services/news_api.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PagingController<int, Article> _pagingController =
      PagingController(firstPageKey: 1);

  Filters filters = Filters(
      isEverythingMode: true,
      searchQuery: "Tesla",
      language: 'en',
      country: 'us',
      category: null,
      from: null,
      to: null,
      sortBy: 'publishedAt');

  @override
  void initState() {
    _pagingController.addPageRequestListener((page) {
      fetch(_pagingController, page, filters);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SearchTopBar(
              filters: filters,
              onFiltersChanged: (newFilters) => _updateFilters(newFilters),
              onChanged: (searchTerm) => _updateQuery(searchTerm),
            ),
            PagedSliverList<int, Article>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Article>(
                animateTransitions: true,
                itemBuilder: (context, item, index) => ArticleListItem(
                  article: item,
                ),
              ),
            ),
          ],
        ),
      );

  void _updateQuery(String searchTerm) {
    filters = filters.copyWith(searchQuery: searchTerm);
    _pagingController.refresh();
  }

  void _updateFilters(Filters newFilters) {
    setState(() {
      filters = newFilters;
    });

    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
