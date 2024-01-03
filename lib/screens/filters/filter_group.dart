import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/filters.dart';

class Option {
  final String name;
  final String code;

  Option(this.name, this.code);
}

class FilterGroup extends StatelessWidget {
  const FilterGroup({
    Key? key,
    required this.title,
    required this.filters,
    required this.onFilterChanged,
    required this.icon,
    required this.singleSelection,
    required this.wrapWidth,
    required this.options,
    required this.selectedOptions,
    this.bringToFront = false,
    required this.canSelectNone,
  }) : super(key: key);

  final String title;
  final String selectedOptions;
  final bool bringToFront;
  final Filters filters;
  final Function(String) onFilterChanged;
  final IconData icon;
  final bool singleSelection;
  final bool canSelectNone;
  final double wrapWidth;
  final List<Option> options;

  void _onChipClicked(_, isSelected, selectedOptionsList, option) {
    if (!singleSelection) {
      isSelected
          ? selectedOptionsList.remove(option.code)
          : selectedOptionsList.add(option.code);

      selectedOptionsList.remove('');

      final newOptions = selectedOptionsList.join(',');

      onFilterChanged(newOptions);
    } else {
      if (isSelected) {
        selectedOptionsList.clear();
      } else {
        selectedOptionsList
          ..clear()
          ..add(option.code);
      }

      final newOptions = selectedOptionsList.join(',');
      onFilterChanged(newOptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedOptionsList = selectedOptions.split(',');

    if (bringToFront) {
      options.sort((a, b) => selectedOptionsList.contains(a.code) ? -1 : 1);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            Text(title),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: wrapWidth,
            child: Wrap(
              children: options.map((option) {
                final isSelected = selectedOptionsList.contains(option.code);

                return ChoiceChip(
                  label: Text(option.name),
                  selected: isSelected,
                  onSelected: (_) {
                    _onChipClicked(_, isSelected, selectedOptionsList, option);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
