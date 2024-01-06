import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_news_app/models/articles.dart';
import 'package:flutter_news_app/models/users.dart';

const String articlesTable = 'articles';
const String usersTable = 'users';

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

  Future<void> registerUser(
      String uid, String name, String email, List<Article> favArt) async {
    await _firestore.collection(usersTable).doc(uid).set({
      'name': name,
      'email': email,
      'favorite_articles': favArt,
    });
  }

  Future<void> getUserFavorites(String uid) async {
    final user = await _firestore.collection(usersTable).doc(uid).get();
    return user.get('favorite_articles');
  }

  Future<void> addArticleToFavorites(String uid, Article article) async {
    await _firestore.collection(usersTable).doc(uid).update({
      'favorite_articles': FieldValue.arrayUnion([article.toJson()])
    });
  }

  Future<void> removeArticleFromFavorites(String uid, Article article) async {
    await _firestore.collection(usersTable).doc(uid).update({
      'favorite_articles': FieldValue.arrayRemove([article.toJson()])
    });
  }

  Future<UserData> getUser(String uid) async {
    final user = await _firestore.collection(usersTable).doc(uid).get();
    return UserData.fromJson(user.data()!);
  }

  Future<void> removeAllArticlesFromUser(String uid) async {
    await _firestore
        .collection(usersTable)
        .doc(uid)
        .update({'favorite_articles': []});
  }
}
