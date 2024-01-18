import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_news_app/main.dart';
import 'package:flutter_news_app/models/users.dart';
import 'package:flutter_news_app/models/article.dart';

const String articlesTable = 'articles';
const String usersTable = 'users';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

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
