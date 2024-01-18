import 'package:flutter_news_app/models/source.dart';

class Article {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article(
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  );

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      Source.fromJson(json["source"]),
      json["author"].toString(),
      json["title"].toString(),
      json["description"].toString(),
      json["url"].toString(),
      json["urlToImage"].toString(),
      json["publishedAt"].toString(),
      json["content"].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "source": source.toJson(),
      "author": author,
      "title": title,
      "description": description,
      "url": url,
      "urlToImage": urlToImage,
      "publishedAt": publishedAt,
      "content": content,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          runtimeType == other.runtimeType &&
          source == other.source &&
          author == other.author &&
          title == other.title &&
          description == other.description &&
          url == other.url &&
          urlToImage == other.urlToImage &&
          publishedAt == other.publishedAt &&
          content == other.content;

  static List<Article> parseList(List<dynamic> list) {
    return list.map((e) => Article.fromJson(e)).toList();
  }

  @override
  int get hashCode => Object.hash(
        source,
        author,
        title,
        description,
        url,
        urlToImage,
        publishedAt,
        content,
      );
}
