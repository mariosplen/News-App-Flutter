import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_news_app/main.dart';
import 'package:flutter_news_app/models/articles.dart';
import 'package:flutter_news_app/models/categories.dart';
import 'package:flutter_news_app/models/users.dart';

const String articlesTable = 'articles';
const String usersTable = 'users';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Query<Article> getArticles(
      List<String> selectedCateg, String searchQuery, String orderBy) {
    // if no category is selected then select all categories
    if (selectedCateg.isEmpty) {
      selectedCateg = categories.map((e) => e.name).toList();
    }

    // if search is provided
    if (searchQuery.isNotEmpty) {
      final search = StringUtils.capitalize(searchQuery);
      return _firestore
          .collection(articlesTable)
          .where('category', whereIn: selectedCateg)
          .where('title', isGreaterThanOrEqualTo: search)
          .where('title', isLessThan: '${search}z')
          .withConverter<Article>(
            fromFirestore: (snapshots, _) =>
                Article.fromJson(snapshots.data()!),
            toFirestore: (article, _) => article.toJson(),
          );
    }

    return _firestore
        .collection(articlesTable)
        .orderBy(orderBy)
        .where('category', whereIn: selectedCateg)
        .withConverter<Article>(
          fromFirestore: (snapshots, _) => Article.fromJson(snapshots.data()!),
          toFirestore: (article, _) => article.toJson(),
        );
  }

  Future<void> setRandomAvatar(String uid) async {
    Random random = Random();
    int randomIndex = random.nextInt(100);
    await _firestore.collection(usersTable).doc(uid).update({
      'avatar_url': 'https://picsum.photos/id/$randomIndex/200/200',
    });
  }

  Future<void> registerUser(String uid, String name, String email,
      List<Article> favArt, String avatarUrl) async {
    await _firestore.collection(usersTable).doc(uid).set({
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
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
    try {
      final user = await _firestore.collection(usersTable).doc(uid).get();
      return UserData.fromJson(user.data()!);
    } catch (e) {
      // If user doesn't exist in firestore, sign out
      e.log();
      FirebaseAuth.instance.signOut();
    }
    // If user doesn't exist in firestore, return empty user
    return UserData(
        name: '',
        email: '',
        avatarUrl: '',
        favoriteArticles: [],
        openedArticles: []);
  }

  Future<void> removeAllArticlesFromUser(String uid) async {
    await _firestore
        .collection(usersTable)
        .doc(uid)
        .update({'favorite_articles': []});
  }

  Future<void> addArticleToOpened(String uid, Article article) async {
    await _firestore.collection(usersTable).doc(uid).update({
      'opened_articles': FieldValue.arrayUnion([article.toJson()])
    });
  }

  Future<int> getOpenedArticlesCount(String uid) async {
    final user = await _firestore.collection(usersTable).doc(uid).get();
    return user.get('opened_articles').length;
  }

  Future<int> getFavoriteArticlesCount(String uid) async {
    final user = await _firestore.collection(usersTable).doc(uid).get();
    return user.get('favorite_articles').length;
  }
}
