import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_news_app/models/articles.dart';

const String articlesTable = 'articles';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Query<Article> getArticles(List<String> categories) {
    Query<Article> query = _firestore
        .collection(articlesTable)
        .withConverter<Article>(
          fromFirestore: (snapshots, _) => Article.fromJson(snapshots.data()!),
          toFirestore: (article, _) => article.toJson(),
        );

    if (categories.isNotEmpty) {
      query = query.where('category', whereIn: categories);
    }

    return query;
  }

  // // Register a new user on the firestore database
  // Future<void> registerUser(String uid, String email) async {
  //   await _firestore.collection('users').doc(uid).set({
  //     'email': email,
  //     'favorite_articles': [],
  //   });
  // }
}
