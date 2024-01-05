import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/categories.dart';
import 'package:flutter_news_app/screens/drawer/category_button.dart';

class FiltersDrawer extends StatelessWidget {
  const FiltersDrawer({
    super.key,
    required this.selectedCategories,
    required this.onSelectedCategoriesChanged,
  });

  final List<String> selectedCategories;
  final Function onSelectedCategoriesChanged;

  static const padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) => Drawer(
        child: Container(
          color: const Color.fromRGBO(50, 55, 205, 1),
          child: ListView(
            children: <Widget>[
              buildHeader(
                context,
                name: "John Doe",
                email: "johndoe13@gmail.com",
              ),
              Container(
                padding: padding,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Categories',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const Divider(color: Colors.white70),
                    ...categories
                        .map((category) => CategoryButton(
                              icon: category.icon,
                              text: StringUtils.capitalize(category.name),
                              value: category.name,
                              selected:
                                  selectedCategories.contains(category.name),
                              onClicked: (value) {
                                onSelectedCategoriesChanged(value);
                              },
                            ))
                        .toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildHeader(
    BuildContext context, {
    required String name,
    required String email,
  }) =>
      Container(
        padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                print("logout");
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            )
          ],
        ),
      );
}
