import 'package:flutter_news_app/models/articles.dart';

class UserData {
  UserData({
    required this.email,
    required this.name,
    required this.favoriteArticles,
    required this.openedArticles,
    required this.avatarUrl,
  });

  final String email;
  final String name;
  final List<Article> favoriteArticles;
  final List<Article> openedArticles;
  final String avatarUrl;

  UserData.fromJson(Map<String, dynamic> json)
      : email = json['email'].toString(),
        avatarUrl = json['avatar_url'].toString(),
        name = json['name'].toString(),
        openedArticles =
            Article.fromJsonListDynamic(json['opened_articles'] ?? []),
        favoriteArticles =
            Article.fromJsonListDynamic(json['favorite_articles'] ?? []);

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'opened_articles': Article.fromJsonListDynamic(openedArticles),
      'favorite_articles': Article.fromJsonListDynamic(favoriteArticles),
    };
  }
}
