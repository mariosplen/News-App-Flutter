import 'package:flutter_news_app/models/articles.dart';
import 'package:firebase_database/firebase_database.dart';

const String articlesTable = 'articles';

class DatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // pushes or removes an article from the users favorite articles
  Future<void> toggleFavoriteArticle(String uid, Article article) async {
    var currentArticles = await getCurrentFavoriteArticles(uid);

    final bool isFavorite = currentArticles.contains(article);

    if (isFavorite) {
      currentArticles.remove(article);
      await _database
          .ref()
          .child('users')
          .child(uid)
          .child('favorite_articles')
          .set(Article.toJsonList(currentArticles));
    } else {
      currentArticles.add(article);
      await _database
          .ref()
          .child('users')
          .child(uid)
          .child('favorite_articles')
          .set(Article.toJsonList(currentArticles));
    }
  }

  // get the users favorite articles
  Future<List<Article>> getCurrentFavoriteArticles(String uid) {
    return _database
        .ref()
        .child('users')
        .child(uid)
        .child('favorite_articles')
        .get()
        .then((DataSnapshot? data) {
      List<Map<String, dynamic>> currentArticles = [];

      var list = data!.value;
      if (list is List) {
        for (var element in list) {
          if (element is Map<Object?, Object?>) {
            currentArticles.add(
              element.map(
                  (key, value) => MapEntry(key.toString(), value.toString())),
            );
          }
        }
      }

      return Article.fromJsonList(currentArticles);
    });
  }
}
