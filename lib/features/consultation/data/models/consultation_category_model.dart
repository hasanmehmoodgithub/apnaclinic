import '../../domain/entities/ai_screening_entity.dart';
import '../../domain/entities/consultation_categories_page_entity.dart';
import '../../domain/entities/consultation_category_entity.dart';

class ConsultationCategoryModel extends ConsultationCategoryEntity {
  const ConsultationCategoryModel({
    required super.id,
    required super.title,
    required super.displayLabel,
    required super.description,
    required super.iconUrl,
    required this.displayOrder,
    required this.isActive,
  });

  final int displayOrder;
  final bool isActive;

  factory ConsultationCategoryModel.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? '').toString().trim();
    final displayLabel = (json['displayLabel'] ?? title).toString().trim();
    final description = (json['description'] ?? displayLabel).toString().trim();
    final order =
        (json['rankOrder'] as num?)?.toInt() ??
        (json['displayOrder'] as num?)?.toInt() ??
        0;

    return ConsultationCategoryModel(
      id: (json['id'] ?? '').toString(),
      title: title,
      displayLabel: displayLabel,
      description: description.isNotEmpty ? description : title,
      iconUrl: (json['iconPath'] ?? json['iconUrl'] ?? '').toString().trim(),
      displayOrder: order,
      isActive: _readIsActive(json['isActive']),
    );
  }

  factory ConsultationCategoryModel.fromMap(Map<String, dynamic> map) =>
      ConsultationCategoryModel.fromJson(map);

  static bool _readIsActive(dynamic raw) {
    return switch (raw) {
      bool value => value,
      int value => value == 1,
      String value => value.toLowerCase() == 'true' || value == '1',
      _ => true,
    };
  }
}

class AiScreeningModel {
  const AiScreeningModel({
    required this.link,
    required this.show,
    required this.permissions,
  });

  final String link;
  final bool show;
  final List<String> permissions;

  factory AiScreeningModel.fromJson(Map<String, dynamic> json) {
    final rawPermissions = json['permission'] ?? json['permissions'];
    final permissions = (rawPermissions is List ? rawPermissions : const [])
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);

    return AiScreeningModel(
      link: (json['link'] ?? json['url'] ?? '').toString().trim(),
      show: _readBool(json['show']),
      permissions: permissions,
    );
  }

  AiScreeningEntity toEntity() {
    return AiScreeningEntity(
      link: link,
      show: show,
      permissions: permissions,
    );
  }

  static bool _readBool(dynamic raw) {
    return switch (raw) {
      bool value => value,
      int value => value == 1,
      String value => value.toLowerCase() == 'true' || value == '1',
      _ => false,
    };
  }
}

class ConsultationCategoriesResponseModel {
  const ConsultationCategoriesResponseModel({
    required this.success,
    required this.message,
    required this.categories,
    this.aiScreening,
  });

  final bool success;
  final String message;
  final List<ConsultationCategoryModel> categories;
  final AiScreeningModel? aiScreening;

  factory ConsultationCategoriesResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final parsed = _parseData(json['data'] ?? json['categories']);

    final list = parsed.categories
        .map(ConsultationCategoryModel.fromJson)
        .where((item) => item.isActive && item.title.isNotEmpty)
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return ConsultationCategoriesResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      categories: list,
      aiScreening: parsed.aiScreening == null
          ? null
          : AiScreeningModel.fromJson(parsed.aiScreening!),
    );
  }

  ConsultationCategoriesPageEntity toEntity() {
    return ConsultationCategoriesPageEntity(
      categories: List<ConsultationCategoryEntity>.from(categories),
      aiScreening: aiScreening?.toEntity(),
    );
  }

  static _ParsedDoctorCategoriesData _parseData(dynamic data) {
    if (data is Map<String, dynamic>) {
      final rawCategories =
          data['categories'] ?? data['data'] ?? const <dynamic>[];
      final rawScreening = data['ai_screening'] ?? data['aiScreening'];
      return _ParsedDoctorCategoriesData(
        categories: (rawCategories is List ? rawCategories : const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList(growable: false),
        aiScreening: rawScreening is Map<String, dynamic> ? rawScreening : null,
      );
    }

    final list = (data is List ? data : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);
    return _ParsedDoctorCategoriesData(categories: list);
  }
}

class _ParsedDoctorCategoriesData {
  const _ParsedDoctorCategoriesData({
    required this.categories,
    this.aiScreening,
  });

  final List<Map<String, dynamic>> categories;
  final Map<String, dynamic>? aiScreening;
}
