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
      title: (json['title'] ?? json['text'] ?? json['query'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? json['section'] ?? '').toString(),
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
      title: (json['title'] ??
              json['displayName'] ??
              json['display_name'] ??
              json['testName'] ??
              json['name'] ??
              '')
          .toString(),
      subtitle: (json['subtitle'] ??
              json['specialtyName'] ??
              json['sampleType'] ??
              json['category'] ??
              '')
          .toString(),
      sectionType: (json['sectionType'] ??
              json['section_type'] ??
              json['type'] ??
              '')
          .toString(),
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
    this.date,
    this.time,
    this.providerLogo,
    this.labLogo,
    this.publicId,
    this.tenantId,
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
  final String? date;
  final String? time;
  final String? providerLogo;
  final String? labLogo;
  final String? publicId;
  final String? tenantId;

  factory SearchResultModel.fromDoctorJson(Map<String, dynamic> json) {
    final experience = json['yearsOfExperience'] ?? json['years_of_experience'];
    final education = (json['education'] ?? '').toString().trim();
    final experienceText = experience == null
        ? ''
        : '${experience.toString().trim()} years Experience';
    final descriptionParts = <String>[
      if (experienceText.isNotEmpty) experienceText,
      if (education.isNotEmpty) education,
    ];

    final partner = json['partner'];
    final partnerMap =
        partner is Map ? Map<String, dynamic>.from(partner) : null;
    final partnerLogo = partnerMap?['logoUrl'] ?? partnerMap?['logo_url'];
    final tenantId = (partnerMap?['tenantId'] ?? partnerMap?['tenant_id'])
        ?.toString()
        .trim();
    final publicId =
        (json['publicId'] ?? json['public_id'] ?? '').toString().trim();
    final apiId = (json['id'] ?? '').toString().trim();

    final ratingRaw = json['ratingScore'] ?? json['rating'] ?? json['ratings'];
    final ratingText = _formatRating(ratingRaw);

    return SearchResultModel(
      id: apiId.isNotEmpty ? apiId : publicId,
      publicId: publicId.isEmpty ? null : publicId,
      tenantId: (tenantId == null || tenantId.isEmpty) ? null : tenantId,
      title: (json['displayName'] ?? json['display_name'] ?? json['name'] ?? '')
          .toString(),
      subtitle: (json['specialtyName'] ?? json['specialty'] ?? '').toString(),
      description:
          descriptionParts.isEmpty ? null : descriptionParts.join('   '),
      imageUrl: (json['profileImageUrl'] ??
              json['profile_image_url'] ??
              json['imageUrl'])
          ?.toString(),
      rating: ratingText,
      fee: _formatMoney(
        json['consultationFee'] ?? json['consultation_fee'] ?? json['fee'],
      ),
      providerLogo: partnerLogo?.toString(),
      primaryActionLabel: 'Book Now',
    );
  }

  /// Lab search hit — uses **only the first** entry in `labs[]`.
  factory SearchResultModel.fromLabTestJson(Map<String, dynamic> json) {
    final labsRaw = json['labs'];
    Map<String, dynamic>? firstLab;
    if (labsRaw is List) {
      for (final item in labsRaw) {
        if (item is Map) {
          firstLab = Map<String, dynamic>.from(item);
          break;
        }
      }
    }

    final sampleType = (json['sampleType'] ?? json['sample_type'] ?? '')
        .toString()
        .trim();
    final labName = (firstLab?['labName'] ?? firstLab?['lab_name'] ?? '')
        .toString()
        .trim();
    final priceRaw =
        firstLab?['finalPrice'] ?? firstLab?['final_price'] ?? firstLab?['price'];

    return SearchResultModel(
      id: (json['testId'] ?? json['test_id'] ?? json['id'] ?? '').toString(),
      title: (json['testName'] ?? json['test_name'] ?? json['name'] ?? '')
          .toString(),
      subtitle: labName,
      description: json['description']?.toString(),
      sampleType: sampleType.isEmpty ? null : sampleType,
      price: _formatMoney(priceRaw),
      hospital: labName.isEmpty ? null : labName,
      providerLabel: labName.isEmpty ? null : labName,
      primaryActionLabel: 'Book Now',
    );
  }

  factory SearchResultModel.fromSurgeryJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: (json['id'] ?? json['slug'] ?? '').toString(),
      title: (json['name'] ?? json['title'] ?? '').toString(),
      subtitle: (json['slug'] ?? '').toString(),
      description: json['description']?.toString(),
      imageUrl: (json['image'] ?? json['imageUrl'] ?? json['image_url'])
          ?.toString(),
      primaryActionLabel: 'Book Now',
    );
  }

  /// Partner pharmacy product shape:
  /// `product_id`, `display_name`, `image_url`, `price`, `manufacturer`,
  /// `category`, `generic_name`, `package_type`, …
  factory SearchResultModel.fromPharmacyJson(Map<String, dynamic> json) {
    final manufacturer =
        (json['manufacturer'] ?? '').toString().trim();
    final category = (json['category'] ?? '').toString().trim();
    final genericName =
        (json['generic_name'] ?? json['genericName'] ?? '').toString().trim();
    final packageType =
        (json['package_type'] ?? json['packageType'] ?? '').toString().trim();

    final subtitleParts = <String>[
      if (manufacturer.isNotEmpty) manufacturer,
      if (packageType.isNotEmpty) packageType,
    ];

    return SearchResultModel(
      id: (json['product_id'] ?? json['productId'] ?? json['id'] ?? '')
          .toString(),
      title: (json['display_name'] ??
              json['displayName'] ??
              json['name'] ??
              json['title'] ??
              '')
          .toString(),
      subtitle: subtitleParts.isNotEmpty
          ? subtitleParts.join(' · ')
          : category,
      description: genericName.isEmpty ? null : genericName,
      imageUrl: _pharmacyImageUrl(json),
      price: _formatMoney(json['price']),
      primaryActionLabel: 'Add to Cart',
    );
  }

  static String? _pharmacyImageUrl(Map<String, dynamic> json) {
    final direct = (json['image_url'] ?? json['imageUrl'])?.toString().trim();
    if (direct != null && direct.isNotEmpty) return direct;

    final images = json['images'];
    if (images is! List || images.isEmpty) return null;
    final first = images.first;
    if (first is String && first.trim().isNotEmpty) return first.trim();
    if (first is Map) {
      final url = (first['url'] ?? first['image_url'] ?? first['imageUrl'])
          ?.toString()
          .trim();
      if (url != null && url.isNotEmpty) return url;
    }
    return null;
  }

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('testId') ||
        json.containsKey('test_id') ||
        json.containsKey('testName') ||
        json['labs'] is List) {
      return SearchResultModel.fromLabTestJson(json);
    }
    if (json.containsKey('displayName') ||
        json.containsKey('specialtyName') ||
        json.containsKey('consultationFee')) {
      return SearchResultModel.fromDoctorJson(json);
    }
    if (json.containsKey('product_id') || json.containsKey('productId')) {
      return SearchResultModel.fromPharmacyJson(json);
    }
    if (json.containsKey('slug') &&
        (json.containsKey('name') || json.containsKey('description'))) {
      return SearchResultModel.fromSurgeryJson(json);
    }

    return SearchResultModel(
      id: (json['id'] ?? json['publicId'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      rating: _formatRating(json['rating']),
      fee: _formatMoney(json['fee']),
      price: _formatMoney(json['price']),
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

  static String? _formatMoney(Object? value) {
    if (value == null) return null;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      if (trimmed.toLowerCase().startsWith('rs')) return trimmed;
      final asNum = num.tryParse(trimmed);
      if (asNum != null) {
        final text = asNum % 1 == 0
            ? asNum.toInt().toString()
            : asNum.toStringAsFixed(0);
        return 'Rs. $text';
      }
      return trimmed;
    }
    if (value is num) {
      final text =
          value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(0);
      return 'Rs. $text';
    }
    return value.toString();
  }

  static String? _formatRating(Object? value) {
    if (value == null) return null;
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    final asNum = num.tryParse(raw);
    if (asNum != null) {
      if (asNum <= 0) return null;
      final text = asNum % 1 == 0
          ? asNum.toInt().toString()
          : asNum.toStringAsFixed(1);
      return '$text / 5';
    }
    return raw;
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
    final rawResults = json['results'] ??
        json['items'] ??
        json['data'] ??
        json['list'];
    return SearchSectionModel(
      title: (json['title'] ?? json['name'] ?? json['label'] ?? '').toString(),
      sectionType: (json['sectionType'] ??
              json['section_type'] ??
              json['type'] ??
              '')
          .toString(),
      results: _parseResultList(rawResults, sectionType: null),
    );
  }

  static List<SearchResultModel> _parseResultList(
    dynamic raw, {
    required String? sectionType,
  }) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) {
          final map = Map<String, dynamic>.from(item);
          return switch (sectionType) {
            'doctor_consultation' => SearchResultModel.fromDoctorJson(map),
            'laboratory_tests' => SearchResultModel.fromLabTestJson(map),
            'surgery_booking' => SearchResultModel.fromSurgeryJson(map),
            'pharmacy' => SearchResultModel.fromPharmacyJson(map),
            _ => SearchResultModel.fromJson(map),
          };
        })
        .where((item) => item.title.isNotEmpty || item.id.isNotEmpty)
        .toList(growable: false);
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
    final payload = _unwrapData(json);

    final recentRaw = payload['recentSearches'] ??
        payload['recent_searches'] ??
        json['recentSearches'];
    final popularRaw = payload['popularSearches'] ??
        payload['popular_searches'] ??
        json['popularSearches'];
    final suggestionsRaw = payload['suggestions'] ?? json['suggestions'];

    var sections = _parseSections(
      payload['sections'] ?? json['sections'],
    );
    if (sections.isEmpty) {
      sections = _sectionsFromCategoryMap(payload);
    }

    var suggestions =
        (suggestionsRaw is List ? suggestionsRaw : const <dynamic>[])
            .whereType<Map>()
            .map(
              (item) => SearchSuggestionModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList(growable: false);

    if (suggestions.isEmpty && sections.isNotEmpty) {
      suggestions = sections
          .expand(
            (section) => section.results.take(3).map(
                  (result) => SearchSuggestionModel(
                    title: result.title,
                    subtitle: section.title.isNotEmpty
                        ? 'in ${section.title}'
                        : '',
                    sectionType: section.sectionType,
                  ),
                ),
          )
          .toList(growable: false);
    }

    return SearchResponseModel(
      success: json['success'] == true ||
          (json['code'] is num && (json['code'] as num).toInt() == 200),
      message: (json['message'] ?? '').toString(),
      recentSearches: (recentRaw is List ? recentRaw : const <dynamic>[])
          .whereType<Map>()
          .map(
            (item) => SearchRecentModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(growable: false),
      popularSearches: (popularRaw is List ? popularRaw : const <dynamic>[])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList(growable: false),
      suggestions: suggestions,
      sections: sections,
    );
  }

  static Map<String, dynamic> _unwrapData(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return json;
  }

  static List<SearchSectionModel> _parseSections(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (item) => SearchSectionModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where((section) => section.results.isNotEmpty)
        .toList(growable: false);
  }

  /// Aggregator shape:
  /// `{ doctorConsultation, labTests, surgeryBooking, pharmacy }`.
  static List<SearchSectionModel> _sectionsFromCategoryMap(
    Map<String, dynamic> payload,
  ) {
    const categoryKeys = <String, (String title, String type)>{
      'doctorConsultation': ('Doctor Consultation', 'doctor_consultation'),
      'doctor_consultation': ('Doctor Consultation', 'doctor_consultation'),
      'doctors': ('Doctor Consultation', 'doctor_consultation'),
      'pharmacy': ('Pharmacy', 'pharmacy'),
      'medicines': ('Pharmacy', 'pharmacy'),
      'products': ('Pharmacy', 'pharmacy'),
      'labTests': ('Laboratory Tests', 'laboratory_tests'),
      'lab_tests': ('Laboratory Tests', 'laboratory_tests'),
      'laboratory_tests': ('Laboratory Tests', 'laboratory_tests'),
      'surgeryBooking': ('Surgery Booking', 'surgery_booking'),
      'surgery_booking': ('Surgery Booking', 'surgery_booking'),
      'surgery': ('Surgery Booking', 'surgery_booking'),
      'surgeries': ('Surgery Booking', 'surgery_booking'),
      'procedures': ('Surgery Booking', 'surgery_booking'),
    };

    final sections = <SearchSectionModel>[];
    final seenTypes = <String>{};

    for (final entry in categoryKeys.entries) {
      if (seenTypes.contains(entry.value.$2)) continue;
      final raw = payload[entry.key];
      if (raw is! List || raw.isEmpty) continue;

      final results = SearchSectionModel._parseResultList(
        raw,
        sectionType: entry.value.$2,
      );
      if (results.isEmpty) continue;

      seenTypes.add(entry.value.$2);
      sections.add(
        SearchSectionModel(
          title: entry.value.$1,
          sectionType: entry.value.$2,
          results: results,
        ),
      );
    }
    return sections;
  }
}

SearchSectionType mapSectionType(String raw) {
  switch (raw.trim().toLowerCase()) {
    case 'doctor_consultation':
    case 'doctorconsultation':
    case 'doctor':
    case 'doctors':
      return SearchSectionType.doctorConsultation;
    case 'pharmacy':
    case 'medicines':
    case 'products':
      return SearchSectionType.pharmacy;
    case 'laboratory_tests':
    case 'laboratorytests':
    case 'laboratory':
    case 'lab':
    case 'labs':
    case 'lab_tests':
    case 'labtests':
      return SearchSectionType.laboratoryTests;
    case 'surgery_booking':
    case 'surgerybooking':
    case 'surgery':
    case 'surgeries':
    case 'procedures':
      return SearchSectionType.surgeryBooking;
    default:
      return SearchSectionType.doctorConsultation;
  }
}
