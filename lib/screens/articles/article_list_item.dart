import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/articles.dart';
import 'package:flutter_news_app/screens/articles/article_screen/article_screen.dart';
import 'package:flutter_news_app/services/firestore_service.dart';
import 'package:flutter_news_app/widgets/custom_chip.dart';
import 'package:google_fonts/google_fonts.dart';

/// List item representing a single Article
class ArticleListItem extends StatelessWidget {
  const ArticleListItem({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Card(
        surfaceTintColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 265, // Adjusted height considering the total height
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Use min to avoid unnecessary height
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: article.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 12.0,
                      ),
                      child: SizedBox(
                        height: 60,
                        child: Center(
                          child: Text(
                            article.title,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: GoogleFonts.lora().fontFamily,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 65,
                child: CustomChip(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.85),
                  children: [
                    Text(
                      StringUtils.capitalize(article.category),
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: GoogleFonts.ubuntu().fontFamily,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                )),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.white.withOpacity(0.3),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailsScreen(
                          article: article,
                        ),
                      ),
                    );
                    FirestoreService().addArticleToOpened(
                      FirebaseAuth.instance.currentUser!.uid,
                      article,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
