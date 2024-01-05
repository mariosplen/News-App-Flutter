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

  Article copyWith({
    String? title,
    String? content,
    String? imageUrl,
    String? date,
    String? category,
  }) {
    return Article(
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }

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

  static List<Article> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => Article.fromJson(json)).toList();
  }

  static List<Article> fromObjectList(List<Object?> objectList) {
    return objectList
        .map((object) => Article.fromJson(object as Map<String, dynamic>))
        .toList();
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
