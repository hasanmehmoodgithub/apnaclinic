import 'package:equatable/equatable.dart';

/// Data model for Your MVVM Feature (MVVM - Model layer)
/// Represents data from API or local preference
class YourMvvmModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  const YourMvvmModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  /// Create YourMvvmModel from JSON
  factory YourMvvmModel.fromJson(Map<String, dynamic> json) {
    return YourMvvmModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Convert YourMvvmModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  YourMvvmModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return YourMvvmModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, createdAt];
}
