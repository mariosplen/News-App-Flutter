import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/articles.dart';
import 'package:flutter_news_app/screens/articles/article_list_item.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class ArticleListBuilder extends StatelessWidget {
  const ArticleListBuilder({
    super.key,
    required this.query,
  });

  final Query<Article> query;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Article>(
      pageSize: 4,
      query: query,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              // Check if need to fetch more data
              _fetchMoreArticlesIfEndReached(snapshot, index);

              // The article data
              final article = snapshot.docs[index].data();

              return ArticleListItem(
                article: article,
              );
            },
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching articles!'),
          );
        }

        return const Center(
          child: Text('Something went wrong!'),
        );
      },
    );
  }
}

void _fetchMoreArticlesIfEndReached(
  FirestoreQueryBuilderSnapshot<Article> snapshot,
  int index,
) async {
  await Future.delayed(const Duration(milliseconds: 400));

  final hasEndReached = snapshot.hasMore &&
      (index + 1) == snapshot.docs.length &&
      !snapshot.isFetchingMore;

  if (hasEndReached) {
    snapshot.fetchMore();
  }
}
