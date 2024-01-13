import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/users.dart';
import 'package:flutter_news_app/navigation/bottom_navbar.dart';
import 'package:flutter_news_app/screens/articles/article_screen/article_screen.dart';
import 'package:flutter_news_app/services/firestore_service.dart';
import 'package:flutter_news_app/widgets/profile_stats_item.dart';
import 'package:flutter_news_app/widgets/circle_avatar_button.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.onNewTabSelected});

  final Function onNewTabSelected;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    String userid = FirebaseAuth.instance.currentUser!.uid;
    UserData? userData;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: GoogleFonts.texturina().fontFamily,
            fontSize: 28,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black,
      ),
      bottomNavigationBar: BottomNavbar(
        selected: 1,
        onTap: widget.onNewTabSelected,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: FirestoreService().getUser(userid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              userData = snapshot.data;
              return Column(
                children: [
                  SizedBox(height: 16),
                  CircleAvatarButton(
                    imageUrl: userData!.avatarUrl,
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    iconColor: Theme.of(context).colorScheme.inverseSurface,
                    onTap: () async {
                      await FirestoreService().setRandomAvatar(userid);
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    userData!.name,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userData!.email,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatsItem(
                          title: "Articles Viewed",
                          icon: Icons.remove_red_eye,
                          color: Colors.blue[300]!,
                          value: userData!.openedArticles.length.toString()),
                      StatsItem(
                        title: "Articles Liked",
                        value: userData!.favoriteArticles.length.toString(),
                        icon: Icons.thumb_up,
                        color: Colors.red[300]!,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Favorite Articles",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily:
                                    GoogleFonts.robotoCondensed().fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Clear all?'),
                                        content: const Text(
                                            'Are you sure you want to clear all your favorite articles?'),
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
                                  ).then((value) async {
                                    if (value == true) {
                                      FirestoreService()
                                          .removeAllArticlesFromUser(userid);
                                      setState(() {});
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Color(0xFF8D3F8A),
                                ),
                                label: Text(
                                  "Clear All",
                                  style: TextStyle(color: Color(0XFF8D3F8A)),
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 18.0),
                  Expanded(
                      child: userData!.favoriteArticles.isEmpty
                          ? Center(
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
                            )
                          : ListView.builder(
                              itemCount: userData!.favoriteArticles.length,
                              itemBuilder: (context, index) {
                                var article = userData!.favoriteArticles[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Dismissible(
                                      key: UniqueKey(),
                                      confirmDismiss: (_) {
                                        return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Remove article?'),
                                              content: const Text(
                                                  'Are you sure you want to remove this article from your favorites?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: const Text('No'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      onDismissed: (_) async {
                                        await FirestoreService()
                                            .removeArticleFromFavorites(
                                                userid, article);
                                        setState(() {});
                                      },
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
                                                ))
                                                    .then((_) {
                                                  setState(() {});
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
