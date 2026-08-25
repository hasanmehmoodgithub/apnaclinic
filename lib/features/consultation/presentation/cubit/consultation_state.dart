import 'package:equatable/equatable.dart';

import '../../domain/entities/ai_screening_entity.dart';
import '../../domain/entities/consultation_category_entity.dart';

class ConsultationState extends Equatable {
  final List<ConsultationCategoryEntity> categories;
  final List<ConsultationCategoryEntity> filteredCategories;
  final AiScreeningEntity? aiScreening;
  final bool isLoading;
  final String searchQuery;
  final String? errorMessage;

  const ConsultationState({
    this.categories = const [],
    this.filteredCategories = const [],
    this.aiScreening,
    this.isLoading = false,
    this.searchQuery = '',
    this.errorMessage,
  });

  ConsultationState copyWith({
    List<ConsultationCategoryEntity>? categories,
    List<ConsultationCategoryEntity>? filteredCategories,
    AiScreeningEntity? aiScreening,
    bool? isLoading,
    String? searchQuery,
    String? errorMessage,
    bool clearAiScreening = false,
  }) {
    return ConsultationState(
      categories: categories ?? this.categories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      aiScreening: clearAiScreening ? null : (aiScreening ?? this.aiScreening),
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    filteredCategories,
    aiScreening,
    isLoading,
    searchQuery,
    errorMessage,
  ];
}
