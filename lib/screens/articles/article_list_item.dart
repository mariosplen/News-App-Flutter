import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/articles/article_screen/article_screen.dart';
import 'package:flutter_news_app/services/firestore_service.dart';
import 'package:flutter_news_app/models/article.dart';
import 'package:flutter_news_app/widgets/custom_chip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

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
                      child: _loadImage(article.urlToImage),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 12.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          article.title,
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
                      article.source.name,
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

Image _placeHolderImage = Image.asset(
  'assets/images/placeholder.png',
  fit: BoxFit.cover,
  width: double.infinity,
);

Widget _loadImage(String urlToImage) {
  if (urlToImage == "null") {
    return _placeHolderImage;
  }
  return FadeInImage.memoryNetwork(
    fit: BoxFit.cover,
    width: double.infinity,
    image: urlToImage,
    placeholder: kTransparentImage,
    imageErrorBuilder: (context, error, stackTrace) => _placeHolderImage,
    placeholderErrorBuilder: (context, error, stackTrace) => _placeHolderImage,
  );
}
