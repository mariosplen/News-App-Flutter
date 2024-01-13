import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/main.dart';
import 'package:flutter_news_app/models/articles.dart';
import 'package:flutter_news_app/screens/articles/article_list_item.dart';

class ArticleListBuilder extends StatelessWidget {
  const ArticleListBuilder({
    super.key,
    required this.query,
  });

  final Query<Article> query;

  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      pageSize: 4,
      showFetchingIndicator: true,
      query: query,
      itemBuilder: (context, doc) {
        final article = doc.data();
        return ArticleListItem(
          article: article,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        error.log();
        return Center(
          child: Text(
            'Something went wrong, please check logs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        );
      },
    );
  }
}
