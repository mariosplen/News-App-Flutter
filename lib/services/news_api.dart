import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';

import 'package:flutter_news_app/models/filters.dart';

NewsAPI _newsAPI = NewsAPI("e44d15833154444b8581d5c8cafdad79");

int _pageSize = 10;

Future<void> fetch(
  PagingController<int, Article> pagingController,
  int page,
  Filters filters,
) async {
  try {
    final newItems = filters.isEverythingMode
        ? await _newsAPI.getEverything(
            language: filters.language,
            page: page,
            pageSize: _pageSize,
            query: filters.searchQuery,
            from: filters.from,
            to: filters.to,
            sortBy: filters.sortBy,
          )
        : await _newsAPI.getTopHeadlines(
            page: page,
            pageSize: _pageSize,
            country: filters.country,
            category: filters.category,
            query: filters.searchQuery,
          );

    final isLastPage = newItems.length < _pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = page + 1;
      pagingController.appendPage(newItems, nextPageKey);
    }
  } catch (error) {
    pagingController.error = error;
  }
}
