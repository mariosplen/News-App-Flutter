import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_news_app/models/filters.dart';
import 'package:flutter_news_app/screens/filters/filters.dart';

class SearchTopBar extends StatefulWidget {
  const SearchTopBar({
    super.key,
    this.onChanged,
    this.debounceTime,
    required this.onFiltersChanged,
    required this.filters,
  });

  final void Function(Filters newFilters) onFiltersChanged;
  final Filters filters;
  final ValueChanged<String>? onChanged;
  final Duration? debounceTime;

  @override
  State<SearchTopBar> createState() => _SearchTopBarState();
}

class _SearchTopBarState extends State<SearchTopBar> {
  final StreamController<String> _textChangeStreamController =
      StreamController();
  late StreamSubscription _textChangesSubscription;

  @override
  void initState() {
    _textChangesSubscription = _textChangeStreamController.stream
        .debounceTime(
          widget.debounceTime ??
              const Duration(
                seconds: 1,
              ),
        )
        .distinct()
        .listen((text) {
      final onChanged = widget.onChanged;
      if (onChanged != null) {
        onChanged(text);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => SliverAppBar(
        toolbarHeight: 90,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController()
                  ..text = widget.filters.searchQuery ?? '',
                decoration: InputDecoration(
                  labelText: 'Search',
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                      borderSide: BorderSide.none),
                ),
                onChanged: _textChangeStreamController.add,
              ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              elevation: 0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FiltersScreen(
                      filters: widget.filters,
                      onFiltersChanged: widget.onFiltersChanged,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.tune),
            )
          ],
        ),
        floating: true,
        snap: true,
      );

  @override
  void dispose() {
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }
}
