import 'package:equatable/equatable.dart';

import '../../domain/entities/consultation_category_entity.dart';

class ConsultationState extends Equatable {
  final List<ConsultationCategoryEntity> categories;
  final List<ConsultationCategoryEntity> filteredCategories;
  final bool isLoading;
  final String searchQuery;
  final String? errorMessage;

  const ConsultationState({
    this.categories = const [],
    this.filteredCategories = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.errorMessage,
  });

  ConsultationState copyWith({
    List<ConsultationCategoryEntity>? categories,
    List<ConsultationCategoryEntity>? filteredCategories,
    bool? isLoading,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ConsultationState(
      categories: categories ?? this.categories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    filteredCategories,
    isLoading,
    searchQuery,
    errorMessage,
  ];
}
