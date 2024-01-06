import 'package:flutter_news_app/models/articles.dart';

class UserData {
  UserData({
    required this.email,
    required this.name,
    required this.favoriteArticles,
  });

  final String email;
  final String name;
  final List<Article> favoriteArticles;

  UserData.fromJson(Map<String, dynamic> json)
      : email = json['email'] as String,
        name = json['name'] as String,
        favoriteArticles =
            Article.fromJsonListDynamic(json['favorite_articles'] ?? []);

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'favorite_articles': Article.toJsonList(favoriteArticles),
    };
  }
}
