import 'package:flutter/material.dart';

class BottomNavigationItemWidget extends BottomNavigationBarItem {
  BottomNavigationItemWidget(String label, IconData iconData, this.widget)
      : super(
          label: label,
          icon: Icon(iconData),
        );

  final Widget widget;
}
