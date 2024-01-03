import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/webview/webview.dart';
import 'package:news_api_flutter_package/model/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    Image? articleImage;

    try {
      articleImage = Image.network(article.urlToImage!);
    } catch (e) {
      articleImage = null;
    }

    final title = article.source.name ?? article.title;
    if (title == null) {
      throw Exception('Details Screen');
    }

    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(article.publishedAt!.substring(0, 10)),
        ],
      )),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Text(article.title!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          if (articleImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: articleImage,
            ),
          Text(
            article.description ?? '',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          // Read more button
          if (article.url != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return WebViewScreen(title: title, url: article.url!);
                    },
                  ));
                },
                child: const Text('Read more'),
              ),
            ),
        ],
      )),
    );
  }
}
