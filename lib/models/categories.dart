import 'package:flutter/material.dart';

List<Category> categories = [
  const Category(name: 'sport', icon: Icons.sports_basketball_rounded),
  const Category(name: 'music', icon: Icons.music_note_sharp),
  const Category(name: 'worklife', icon: Icons.work_rounded),
  const Category(name: 'culture', icon: Icons.live_tv_rounded),
  const Category(name: 'future', icon: Icons.rocket_launch),
  const Category(name: 'travel', icon: Icons.flight_takeoff),
  const Category(name: 'opinions', icon: Icons.comment_rounded),
];

class Category {
  final String name;
  final IconData icon;

  const Category({
    required this.name,
    required this.icon,
  });
}
