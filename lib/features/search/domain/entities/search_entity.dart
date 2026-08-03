
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
    this.oldFee,
    this.hospital,
    this.sampleType,
    this.providerLabel,
    this.primaryActionLabel,
    this.date,
    this.time,
    this.providerLogo,
    this.labLogo,
    this.publicId,
    this.tenantId,
    this.doctorId,
    this.cityId,
    this.packageId,
    this.packageName,
  });

  final String id;
  final String title;
  final String subtitle;
  final String? description;
  final String? imageUrl;
  final String? rating;
  final String? fee;
  final String? price;
  final String? oldFee;
  final String? hospital;
  final String? sampleType;
  final String? providerLabel;
  final String? primaryActionLabel;

  /// Doctor `publicId` from search API (preferred booking identity when set).
  final String? publicId;

  /// Doctor partner `tenantId` for consultation booking.
  final String? tenantId;

  /// Surgery offer — doctor id for patient-details booking.
  final String? doctorId;

  /// Surgery offer — city id from search API.
  final String? cityId;

  /// Surgery offer — package id.
  final String? packageId;

  /// Surgery offer — package / procedure display name.
  final String? packageName;

  /// Appointment/availability date shown as a pill on doctor cards
  /// (e.g. "10/09/24").
  final String? date;

  /// Appointment/availability time shown as a pill on doctor cards
  /// (e.g. "1pm - 2pm").
  final String? time;

  /// Small circular provider logo shown in the top-right of doctor / lab
  /// cards (e.g. "MediQ", "Oladoc"). Asset path or remote URL — pick one
  /// convention and use it consistently.
  final String? providerLogo;

  /// Lab logo shown inside the grey image tile on laboratory-test cards
  /// (e.g. "IDC Islamabad"). Separate from providerLogo so you can render
  /// both at once.
  final String? labLogo;
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