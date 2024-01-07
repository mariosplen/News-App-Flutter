import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_news_app/models/articles.dart';
import 'package:flutter_news_app/models/categories.dart';
import 'package:flutter_news_app/models/users.dart';

const String articlesTable = 'articles';
const String usersTable = 'users';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Query<Article> getArticles(List<String> selectedCateg, String searchQuery) {
    // if search is provided then search on all categories
    if (searchQuery.isNotEmpty) {
      final search = StringUtils.capitalize(searchQuery);
      return _firestore
          .collection(articlesTable)
          .where('title', isGreaterThanOrEqualTo: search)
          .where('title', isLessThan: '${search}z')
          .withConverter<Article>(
            fromFirestore: (snapshots, _) =>
                Article.fromJson(snapshots.data()!),
            toFirestore: (article, _) => article.toJson(),
          );
    }

    // if no category is selected then select all categories
    if (selectedCateg.isEmpty) {
      selectedCateg = categories.map((e) => e.name).toList();
    }
    return _firestore
        .collection(articlesTable)
        .where('category', whereIn: selectedCateg)
        .withConverter<Article>(
          fromFirestore: (snapshots, _) => Article.fromJson(snapshots.data()!),
          toFirestore: (article, _) => article.toJson(),
        );
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
