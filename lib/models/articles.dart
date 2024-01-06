class Article {
  Article({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.date,
  });

  final String title;
  final String content;
  final String imageUrl;
  final String category;
  final String date;

  Article.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String,
        content = json['content'] as String,
        imageUrl = json['image_url'] as String,
        date = json['date'] as String,
        category = json['category'] as String;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'date': date,
      'category': category,
    };
  }

  static List<Map<String, dynamic>> toJsonList(List<Article> articles) {
    return articles.map((article) => article.toJson()).toList();
  }

  static List<Article> fromJsonListDynamic(List<dynamic> jsonList) {
    return jsonList.map((json) => Article.fromJson(json)).toList();
  }

  @override
  int get hashCode =>
      title.hashCode ^
      content.hashCode ^
      imageUrl.hashCode ^
      date.hashCode ^
      category.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          title == other.title &&
          content == other.content &&
          imageUrl == other.imageUrl &&
          date == other.date &&
          category == other.category;
}
