// Filters is a class which has all the paremeters that will be used when making the API call.

class Filters {
  final bool isEverythingMode; // Api has 2 modes: everything & top_headlines
  final String? searchQuery;
  final String? language;
  final String? country;
  final String? category;
  final String? sortBy;
  final DateTime? from;
  final DateTime? to;

  Filters({
    required this.isEverythingMode,
    required this.searchQuery,
    required this.language,
    required this.country,
    required this.category,
    required this.from,
    required this.to,
    required this.sortBy,
  });

  Filters copyWith({
    bool? isEverythingMode,
    String? searchQuery,
    String? language,
    String? country,
    String? category,
    DateTime? from,
    DateTime? to,
    String? sortBy,
  }) {
    return Filters(
      isEverythingMode: isEverythingMode ?? this.isEverythingMode,
      searchQuery: searchQuery ?? this.searchQuery,
      language: language ?? this.language,
      country: country ?? this.country,
      category: category ?? this.category,
      from: from ?? this.from,
      to: to ?? this.to,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  int get hashCode =>
      isEverythingMode.hashCode ^
      searchQuery.hashCode ^
      language.hashCode ^
      country.hashCode ^
      category.hashCode ^
      from.hashCode ^
      to.hashCode ^
      sortBy.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Filters &&
          isEverythingMode == other.isEverythingMode &&
          searchQuery == other.searchQuery &&
          language == other.language &&
          country == other.country &&
          category == other.category &&
          from == other.from &&
          to == other.to &&
          sortBy == other.sortBy;

  @override
  String toString() {
    return 'Filters{isEverythingMode: $isEverythingMode, searchQuery: $searchQuery, language: $language, country: $country, category: $category, from: $from, to: $to, sortBy: $sortBy}';
  }
}
