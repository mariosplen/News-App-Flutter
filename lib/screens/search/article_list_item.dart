import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/search/article_detail.dart';
import 'package:news_api_flutter_package/model/article.dart';

/// List item representing a single Article
class ArticleListItem extends StatelessWidget {
  const ArticleListItem({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    Image? articleImage;

    try {
      articleImage = Image.network(article.urlToImage!);
    } catch (e) {
      articleImage = null;
    }

    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: articleImage?.image,
      ),
      title: Text(article.title!),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ArticleDetailScreen(article: article);
          },
        ));
      },
    );
  }
}
