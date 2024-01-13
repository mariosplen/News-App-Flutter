class Article {
  Article({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.date,
    required this.publishDate,
    required this.url,
    required this.description,
    required this.author,
  });

  final String title;
  final String content;
  final String imageUrl;
  final String category;
  final String date;
  final String publishDate;
  final String url;
  final String description;
  final String author;

  Article.fromJson(Map<String, dynamic> json)
      : title = json['title'].toString(),
        content = json['content'].toString(),
        imageUrl = json['image_url'].toString(),
        date = json['date'].toString(),
        publishDate = json['publish_date'].toString(),
        url = json['url'].toString(),
        author = json['author'].toString(),
        description = json['description'].toString(),
        category = json['category'].toString();

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'date': date,
      'publish_date': publishDate,
      'author': author,
      'url': url,
      'description': description,
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
      publishDate.hashCode ^
      author.hashCode ^
      url.hashCode ^
      description.hashCode ^
      category.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          title == other.title &&
          content == other.content &&
          imageUrl == other.imageUrl &&
          url == other.url &&
          author == other.author &&
          description == other.description &&
          date == other.date &&
          publishDate == other.publishDate &&
          category == other.category;
}
