enum SearchSectionType {
  doctorConsultation,
  pharmacy,
  laboratoryTests,
  surgeryBooking,
}

class SearchRecentEntity {
  const SearchRecentEntity({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
}

class SearchSuggestionEntity {
  const SearchSuggestionEntity({
    required this.title,
    required this.subtitle,
    required this.sectionType,
  });

  final String title;
  final String subtitle;
  final SearchSectionType sectionType;
}

class SearchResultEntity {
  const SearchResultEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    this.description,
    this.imageUrl,
    this.rating,
    this.fee,
    this.price,
    this.hospital,
    this.sampleType,
    this.providerLabel,
    this.primaryActionLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String? description;
  final String? imageUrl;
  final String? rating;
  final String? fee;
  final String? price;
  final String? hospital;
  final String? sampleType;
  final String? providerLabel;
  final String? primaryActionLabel;
}

class SearchSectionEntity {
  const SearchSectionEntity({
    required this.title,
    required this.type,
    required this.results,
  });

  final String title;
  final SearchSectionType type;
  final List<SearchResultEntity> results;
}

class SearchContentEntity {
  const SearchContentEntity({
    required this.recentSearches,
    required this.popularSearches,
    required this.suggestions,
    required this.sections,
  });

  final List<SearchRecentEntity> recentSearches;
  final List<String> popularSearches;
  final List<SearchSuggestionEntity> suggestions;
  final List<SearchSectionEntity> sections;
}
