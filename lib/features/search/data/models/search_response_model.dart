import '../../domain/entities/search_entity.dart';


class SearchRecentModel {
  const SearchRecentModel({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  factory SearchRecentModel.fromJson(Map<String, dynamic> json) {
    return SearchRecentModel(
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
    );
  }
}

class SearchSuggestionModel {
  const SearchSuggestionModel({
    required this.title,
    required this.subtitle,
    required this.sectionType,
  });

  final String title;
  final String subtitle;
  final String sectionType;

  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) {
    return SearchSuggestionModel(
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      sectionType: (json['sectionType'] ?? '').toString(),
    );
  }
}

class SearchResultModel {
  const SearchResultModel({
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
    // New fields needed for the updated UI
    this.date,
    this.time,
    this.providerLogo,
    this.labLogo,
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

  /// Appointment/availability date shown as a pill on doctor cards
  /// (e.g. "10/09/24").
  final String? date;

  /// Appointment/availability time shown as a pill on doctor cards
  /// (e.g. "1pm - 2pm").
  final String? time;

  /// Small circular provider logo shown in the top-right of doctor / lab
  /// cards (e.g. MediQ, Oladoc). Asset path or remote URL.
  final String? providerLogo;

  /// Lab logo shown inside the grey image tile on laboratory-test cards
  /// (e.g. IDC). Separate from [providerLogo] so both can render at once.
  final String? labLogo;

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      rating: json['rating']?.toString(),
      fee: json['fee']?.toString(),
      price: json['price']?.toString(),
      hospital: json['hospital']?.toString(),
      sampleType: json['sampleType']?.toString(),
      providerLabel: json['providerLabel']?.toString(),
      primaryActionLabel: json['primaryActionLabel']?.toString(),
      date: json['date']?.toString(),
      time: json['time']?.toString(),
      providerLogo: json['providerLogo']?.toString(),
      labLogo: json['labLogo']?.toString(),
    );
  }
}

class SearchSectionModel {
  const SearchSectionModel({
    required this.title,
    required this.sectionType,
    required this.results,
  });

  final String title;
  final String sectionType;
  final List<SearchResultModel> results;

  factory SearchSectionModel.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'];
    return SearchSectionModel(
      title: (json['title'] ?? '').toString(),
      sectionType: (json['sectionType'] ?? '').toString(),
      results: (rawResults is List ? rawResults : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(SearchResultModel.fromJson)
          .toList(),
    );
  }
}

class SearchResponseModel {
  const SearchResponseModel({
    required this.success,
    required this.message,
    required this.recentSearches,
    required this.popularSearches,
    required this.suggestions,
    required this.sections,
  });

  final bool success;
  final String message;
  final List<SearchRecentModel> recentSearches;
  final List<String> popularSearches;
  final List<SearchSuggestionModel> suggestions;
  final List<SearchSectionModel> sections;

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    final recentRaw = json['recentSearches'];
    final popularRaw = json['popularSearches'];
    final suggestionsRaw = json['suggestions'];
    final sectionsRaw = json['sections'];

    return SearchResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      recentSearches: (recentRaw is List ? recentRaw : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(SearchRecentModel.fromJson)
          .toList(),
      popularSearches: (popularRaw is List ? popularRaw : const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      suggestions: (suggestionsRaw is List ? suggestionsRaw : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(SearchSuggestionModel.fromJson)
          .toList(),
      sections: (sectionsRaw is List ? sectionsRaw : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(SearchSectionModel.fromJson)
          .toList(),
    );
  }
}

SearchSectionType mapSectionType(String raw) {
  switch (raw) {
    case 'doctor_consultation':
      return SearchSectionType.doctorConsultation;
    case 'pharmacy':
      return SearchSectionType.pharmacy;
    case 'laboratory_tests':
      return SearchSectionType.laboratoryTests;
    case 'surgery_booking':
      return SearchSectionType.surgeryBooking;
    default:
      return SearchSectionType.doctorConsultation;
  }
}
