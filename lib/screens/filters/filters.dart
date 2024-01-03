import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:flutter_news_app/models/countries.dart';
import 'package:flutter_news_app/models/filters.dart';
import 'package:flutter_news_app/screens/filters/filter_group.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
  });

  // The onFiltersChanged callback will pass the new filters
  // to the parent widget, to update the global filters.
  final Filters filters; // Global filters instance.
  final void Function(Filters newFilters) onFiltersChanged;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  // Local filters, used to track changes in the UI. If the user presses the
  // "Done" button, the global filters will be updated with the local filters.
  // Initially, the local filters are the same as the global filters.
  late Filters _filters;

  @override
  void initState() {
    _filters = widget.filters;
    super.initState();
  }

  // Checks if the local filters are different from the global filters.
  // If they are different, the "Done" button will be shown.
  bool get _hasChangedPreferences => _filters != widget.filters;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Preferences',
        ),
        actions: _hasChangedPreferences
            ? [
                IconButton(
                  icon: const Icon(Icons.done),
                  onPressed: () {
                    widget.onFiltersChanged(_filters);
                    Navigator.of(context).pop();
                  },
                )
              ]
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text("Everything"),
                      selected: _filters.isEverythingMode,
                      onSelected: (_) {
                        Filters newFilters = widget.filters.copyWith(
                          isEverythingMode: true,
                        );
                        setState(() {
                          _filters = newFilters;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text("Top Headlines"),
                      selected: !_filters.isEverythingMode,
                      onSelected: (_) {
                        Filters newFilters = widget.filters.copyWith(
                          isEverythingMode: false,
                        );
                        setState(() {
                          _filters = newFilters;
                        });
                      },
                    )
                  ],
                ),
                _filters.isEverythingMode
                    ? Expanded(child: everythingFilters())
                    : Expanded(child: topHeadlinesFilters()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.logout_outlined),
            ),
          )
        ],
      ));

  Widget topHeadlinesFilters() {
    return Column(
      children: [
        Column(
          children: [
            FilterGroup(
                canSelectNone: true,
                title: "Country",
                selectedOptions: _filters.country ?? '',
                filters: _filters,
                onFilterChanged: (newOptions) {
                  setState(() {
                    _filters = _filters.copyWith(country: newOptions);
                  });
                },
                bringToFront: true,
                icon: Icons.flag,
                singleSelection: false,
                wrapWidth: 1400,
                options:
                    countries.map((e) => Option(e.fullName, e.code)).toList()),
            FilterGroup(
                canSelectNone: true,
                title: "Category",
                selectedOptions: _filters.category ?? '',
                filters: _filters,
                onFilterChanged: (newOptions) {
                  setState(() {
                    _filters = _filters.copyWith(category: newOptions);
                  });
                },
                bringToFront: false,
                icon: Icons.category,
                singleSelection: true,
                wrapWidth: MediaQuery.of(context).size.width,
                options: [
                  Option("Business", "business"),
                  Option("Entertainment", "entertainment"),
                  Option("General", "general"),
                  Option("Health", "health"),
                  Option("Science", "science"),
                  Option("Sports", "sports"),
                  Option("Technology", "technology"),
                ]),
          ],
        ),
      ],
    );
  }

  Widget everythingFilters() {
    var datePickerController = DateRangePickerController();

    return Column(
      children: [
        Column(
          children: [
            FilterGroup(
                canSelectNone: true,
                title: "Language",
                selectedOptions: _filters.language ?? '',
                filters: _filters,
                onFilterChanged: (newOptions) {
                  setState(() {
                    _filters = _filters.copyWith(language: newOptions);
                  });
                },
                bringToFront: false,
                icon: Icons.language,
                singleSelection: true,
                wrapWidth: MediaQuery.of(context).size.width,
                options: [
                  Option("Arabic", "ar"),
                  Option("German", "de"),
                  Option("English", "en"),
                  Option("Spanish", "es"),
                  Option("French", "fr"),
                  Option("Hebrew", "he"),
                  Option("Italian", "it"),
                  Option("Dutch", "nl"),
                  Option("Norwegian", "no"),
                  Option("Portuguese", "pt"),
                  Option("Russian", "ru"),
                  Option("Swedish", "sv"),
                  Option("Ukrainian", "uk"),
                  Option("Chinese", "zh"),
                ]),
            FilterGroup(
                canSelectNone: false,
                title: "Sort By",
                selectedOptions: _filters.sortBy ?? '',
                filters: _filters,
                onFilterChanged: (newOptions) {
                  setState(() {
                    _filters = _filters.copyWith(sortBy: newOptions);
                  });
                },
                bringToFront: false,
                icon: Icons.filter_list,
                singleSelection: true,
                wrapWidth: MediaQuery.of(context).size.width,
                options: [
                  Option("Relevancy", "relevancy"),
                  Option("Popularity", "popularity"),
                  Option("Latest", "publishedAt"),
                ]),
            const Row(children: [
              Icon(Icons.edit_calendar),
              Text("Date Range"),
            ]),
            SfDateRangePicker(
              controller: datePickerController,
              monthViewSettings:
                  const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
              selectionMode: DateRangePickerSelectionMode.range,
            ),
            ElevatedButton(
                child: const Text("Clear Date Range"),
                onPressed: () {
                  datePickerController.selectedRange = null;
                }),
          ],
        ),
      ],
    );
  }
}
