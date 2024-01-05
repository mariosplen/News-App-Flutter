import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/articles.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Card(
        elevation: 4,
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
                ],
              ),
            ),
            Positioned(
              bottom: 65,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: Color.fromARGB(255, 255, 208, 181),
                ),
                height: 32,
                width: 85,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      StringUtils.capitalize(article.category),
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: GoogleFonts.ubuntu().fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.white.withOpacity(0.3),
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
