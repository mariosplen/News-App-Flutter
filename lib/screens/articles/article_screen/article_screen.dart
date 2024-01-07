import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/articles.dart';
import 'package:flutter_news_app/screens/articles/article_screen/article_body.dart';
import 'package:flutter_news_app/screens/articles/article_screen/article_headline.dart';
import 'package:flutter_news_app/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsScreen extends StatelessWidget {
  ArticleDetailsScreen({
    super.key,
    required this.article,
  });

  final Article article;

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Add listener to prevent scrolling beyond the top, because the image is cropped on top
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 0) _scrollController.jumpTo(0);
    });

    return Scaffold(
      // Transparent appbar, just to show the back button
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              NewsHeadline(article),
              NewsBody(article),
              // NewsBody(article: article),
            ],
          ),
          Positioned(
            right: 24,
            top: MediaQuery.of(context).size.height * 0.377,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Center(
                child: FavButton(article),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: const [0, 0.9],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(1),
                    ],
                  ),
                ),
              )),
          Positioned(
            bottom: 15,
            right: 110,
            left: 110,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFDCE2FA)),
                iconColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              onPressed: () async {
                if (!await launchUrl(Uri.parse(article.imageUrl))) {
                  throw Exception('Could not launch ');
                }
              },
              label: Text(
                "Continue Reading",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              icon: const Icon(Icons.open_in_new),
            ),
          ),
        ],
      ),
    );
  }
}

class FavButton extends StatelessWidget {
  const FavButton(
    this.article, {
    super.key,
  });
  final Article article;

  @override
  Widget build(BuildContext context) {
    var userID = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder(
      future: FirestoreService().getUserFavorites(userID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Article> favArticles =
              Article.fromJsonListDynamic(snapshot.data as List<dynamic>);
          return FavoriteButton(
            iconDisabledColor:
                Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
            iconSize: 60,
            isFavorite: favArticles.contains(article),
            valueChanged: (isFavorited) {
              // Notify the user that the article was added/removed from favorites
              isFavorited
                  ? ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Article added to favorites'),
                        duration: Duration(seconds: 1),
                      ),
                    )
                  : null;

              isFavorited
                  ? FirestoreService().addArticleToFavorites(userID, article)
                  : FirestoreService()
                      .removeArticleFromFavorites(userID, article);
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
