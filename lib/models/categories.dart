import 'package:flutter/material.dart';

List<Category> categories = [
  const Category(name: 'business', icon: Icons.business_center),
  const Category(name: 'entertainment', icon: Icons.live_tv_rounded),
  const Category(name: 'general', icon: Icons.public_rounded),
  const Category(name: 'health', icon: Icons.local_hospital_rounded),
  const Category(name: 'science', icon: Icons.rocket_launch),
  const Category(name: 'sports', icon: Icons.sports_basketball_rounded),
  const Category(name: 'technology', icon: Icons.devices_other_rounded),
];

List<String> categoriesAll = categories.map((e) => e.name).toList();

class Category {
  final String name;
  final IconData icon;

  const Category({
    required this.name,
    required this.icon,
  });
}
