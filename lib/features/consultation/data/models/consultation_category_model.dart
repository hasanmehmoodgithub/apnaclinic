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

    return ConsultationCategoryModel(
      id: (json['id'] ?? '').toString(),
      title: title,
      displayLabel: displayLabel,
      description: description.isNotEmpty ? description : title,
      iconUrl: (json['iconPath'] ?? json['iconUrl'] ?? '').toString().trim(),
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
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

class ConsultationCategoriesResponseModel {
  const ConsultationCategoriesResponseModel({
    required this.success,
    required this.message,
    required this.categories,
  });

  final bool success;
  final String message;
  final List<ConsultationCategoryModel> categories;

  factory ConsultationCategoriesResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final raw = json['data'] ?? json['categories'] ?? [];
    final list = (raw is List ? raw : <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(ConsultationCategoryModel.fromJson)
        .where((item) => item.isActive && item.title.isNotEmpty)
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return ConsultationCategoriesResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      categories: list,
    );
  }
}
