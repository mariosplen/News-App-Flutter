import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_news_app/models/response.dart';
import 'package:flutter_news_app/screens/articles/article_list_item.dart';
import 'package:flutter_news_app/models/article.dart';
import 'package:flutter_news_app/services/news_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final _newsApi = NewsAPI(dotenv.env['API_KEY']!);

class ArticleListBuilder extends StatefulWidget {
  const ArticleListBuilder({
    super.key,
    required this.loadedArticles,
    this.selectedCategory,
    required this.searchQuery,
    required this.selectedSortBy,
  });

  final List<Article> loadedArticles;
  final String? selectedCategory;
  final String searchQuery;
  final String selectedSortBy;

  @override
  State<ArticleListBuilder> createState() => _ArticleListBuilderState();
}

class _ArticleListBuilderState extends State<ArticleListBuilder> {
  final _scrollController = ScrollController();

  final pageSize = 10;
  int _currentPage = 0;
  ResponseModel? _responseData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getArticles().then((value) {
      _scrollController.addListener(_loadMoreData);
    });
  }

  @override
  void didUpdateWidget(covariant ArticleListBuilder oldWidget) {
    _currentPage = 0;

    _getArticles();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // No response from API yet
    if (_responseData == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
    // Error response from API
    if (_responseData!.status == "error") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_responseData!.message!),
          TextButton(
            onPressed: _getArticles,
            child: Text("Retry"),
          ),
        ],
      );
    }

    // No articles found
    if (_responseData!.status == "ok") {
      if (_responseData!.totalResults == 0) {
        return Center(
          child: Text("No articles found"),
        );
      }
    }
    // Articles found
    if (_responseData!.status == "ok") {
      if (widget.loadedArticles.length > 0) {
        return ListView.builder(
          itemCount: widget.loadedArticles.length,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: false,
          controller: _scrollController,
          itemBuilder: (context, index) {
            final article = widget.loadedArticles[index];

            return Column(
              children: [
                ArticleListItem(article: article),
                if (index == widget.loadedArticles.length - 1 && _isLoading)
                  const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SpinKitThreeBounce(
                        color: Colors.blue,
                        size: 20.0,
                      )),
              ],
            );
          },
        );
      }
    }
    // Loading articles
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _loadMoreData() {
    setState(() {
      _isLoading = true;
    });
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _responseData != null &&
        widget.loadedArticles.length < _responseData!.totalResults!) {
      _getArticles();
    }
  }

  Future<void> _getArticles() async {
    _currentPage++;
    final responseModel = await _newsApi.getArticles(
        sortBy: widget.selectedSortBy,
        query: widget.searchQuery,
        category: widget.selectedCategory,
        pageSize: pageSize,
        page: _currentPage);

    if (responseModel.status != "ok") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseModel.message!),
        ),
      );
      setState(() {
        widget.loadedArticles.clear();
        _responseData = responseModel;
      });
      return;
    }
    setState(() {
      widget.loadedArticles.addAll(responseModel.articles!);
      _responseData = responseModel;
      _isLoading = false;
    });
  }
}
