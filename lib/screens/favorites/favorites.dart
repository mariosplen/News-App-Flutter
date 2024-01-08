import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/articles.dart';
import 'package:flutter_news_app/navigation/bottom_navbar.dart';
import 'package:flutter_news_app/screens/articles/article_screen/article_screen.dart';
import 'package:flutter_news_app/services/firestore_service.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key, required this.onNewTabSelected});
  final Function onNewTabSelected;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    var userid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
        bottomNavigationBar: BottomNavbar(
          selected: 1,
          onTap: widget.onNewTabSelected,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Favorite articles',
                      style: TextStyle(
                        fontSize: 36,
                        fontFamily: GoogleFonts.robotoCondensed().fontFamily,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: IconButton(
                        onPressed: () {
                          FirestoreService().removeAllArticlesFromUser(userid);
                          // Navigate back to the articles screen
                          widget.onNewTabSelected(0);
                        },
                        icon: const Icon(Icons.delete),
                        iconSize: 30,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder(
                    future: FirestoreService().getUserFavorites(userid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          (snapshot.data as List<dynamic>).isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'You have no favorite articles yet',
                                style: TextStyle(
                                  fontSize: 24,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Go back to the articles screen and add some!',
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        List<Article> favArticles = Article.fromJsonListDynamic(
                            snapshot.data as List<dynamic>);
                        return ListView.builder(
                          itemCount: favArticles.length,
                          itemBuilder: (context, index) {
                            var article = favArticles[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Dismissible(
                                confirmDismiss: (_) {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Remove article?'),
                                        content: const Text(
                                            'Are you sure you want to remove this article from your favorites?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text('No'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                onDismissed: (_) {
                                  FirestoreService().removeArticleFromFavorites(
                                      userid, article);
                                },
                                key: Key(article.toString()),
                                child: Card(
                                  child: SizedBox(
                                    height: 90,
                                    child: Center(
                                      child: ListTile(
                                        leading: Image.network(
                                          article.imageUrl,
                                        ),
                                        title: Text(
                                          article.title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                ArticleDetailsScreen(
                                              article: article,
                                            ),
                                          ));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
