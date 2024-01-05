import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String value;
  final String text;
  final bool selected;
  final Function onClicked;

  const CategoryButton({
    super.key,
    required this.icon,
    required this.text,
    required this.value,
    required this.selected,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          trailing: Checkbox(
            checkColor: Colors.white,
            value: selected,
            onChanged: null,
          ),
          onTap: () => onClicked(value),
        ),
      );
}
