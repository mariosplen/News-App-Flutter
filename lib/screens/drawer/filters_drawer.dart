import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/categories.dart';
import 'package:flutter_news_app/screens/drawer/category_button.dart';

class FiltersDrawer extends StatelessWidget {
  const FiltersDrawer({
    super.key,
    required this.selectedCategory,
    required this.onSelectedCategoriesChanged,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.onSignOut,
  });

  final String? selectedCategory;
  final Function onSelectedCategoriesChanged;
  final String name;
  final String email;
  final String imageUrl;
  final VoidCallback onSignOut;

  static const padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) => Drawer(
        child: Container(
          color: Theme.of(context).colorScheme.tertiary,
          child: ListView(
            children: <Widget>[
              buildHeader(
                context,
                name: name,
                imageUrl: imageUrl,
                email: email,
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
                              selected: selectedCategory == category.name,
                              onClicked: (value) {
                                if (selectedCategory == value) {
                                  onSelectedCategoriesChanged(null);
                                  return;
                                }
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

  Widget buildHeader(BuildContext context,
          {required String name,
          required String email,
          required String imageUrl}) =>
      Container(
        padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                const SizedBox(height: 15),
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
              onPressed: onSignOut,
              icon: const Icon(Icons.logout, color: Colors.white),
            )
          ],
        ),
      );
}
