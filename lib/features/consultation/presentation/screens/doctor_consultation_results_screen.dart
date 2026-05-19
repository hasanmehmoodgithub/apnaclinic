import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/di/dependency_injection.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/mock/consultation_categories_mock_api.dart';
import '../../data/mock/consultation_doctors_mock_api.dart';
import '../constants/consultation_ui_config.dart';
import '../widgets/results_doctor_card.dart';
import '../widgets/results_doctor_category_card.dart';
import '../widgets/results_doctor_item.dart';
import '../widgets/results_filter_button.dart';
import '../widgets/results_search_field.dart';
import '../widgets/results_select_categories_dialog.dart';
import '../widgets/consultation_screen_header_widget.dart';
import '../widgets/consultation_hero_banner_widget.dart';

class DoctorConsultationResultsScreen extends StatefulWidget {
  final String selectedCategory;

  const DoctorConsultationResultsScreen({
    super.key,
    required this.selectedCategory,
  });

  @override
  State<DoctorConsultationResultsScreen> createState() =>
      _DoctorConsultationResultsScreenState();
}

class _DoctorConsultationResultsScreenState
    extends State<DoctorConsultationResultsScreen> {
  final ConsultationCategoriesMockApi _categoriesApi =
      sl<ConsultationCategoriesMockApi>();
  final ConsultationDoctorsMockApi _doctorsApi = sl<ConsultationDoctorsMockApi>();
  final TextEditingController _searchController = TextEditingController();
  List<String> _categoryOptions = const [];

  List<ResultsDoctorItem> _allDoctors = const [];
  bool _isLoading = false;
  String _query = '';
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _loadCategories();
    _loadDoctors();
  }

  Future<void> _loadCategories() async {
    try {
      final response = await _categoriesApi.getConsultationCategoriesSuccessResponse();
      final categories =
          (response['categories'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<Map<String, dynamic>>()
              .map((item) => (item['title'] as String? ?? '').trim())
              .where((item) => item.isNotEmpty)
              .toList(growable: false);
      if (!mounted) return;
      setState(() {
        _categoryOptions = categories;
      });
    } catch (_) {
      // Keep fallback behavior if mock category API fails.
    }
  }

  Future<void> _openSelectCategoryDialog() async {
    final category = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (context) => ResultsSelectCategoriesDialog(
        selectedCategory: _selectedCategory,
        categories: _categoryOptions,
      ),
    );
    if (category == null || category == _selectedCategory) return;
    setState(() => _selectedCategory = category);
    await _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);
    try {
      final response = await _doctorsApi.getDoctorsResponse(
        category: _selectedCategory,
      );
      final doctors =
          (response['doctors'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<Map<String, dynamic>>()
              .map(ResultsDoctorItem.fromMap)
              .toList(growable: false);
      if (!mounted) return;
      setState(() {
        _allDoctors = doctors;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _allDoctors = const [];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return _buildFullScreenShimmer(context);
    }

    final textTheme = Theme.of(context).textTheme;
    final doctors = _allDoctors.where((doctor) {
      final query = _query.toLowerCase().trim();
      if (query.isEmpty) {
        return true;
      }
      return doctor.name.toLowerCase().contains(query) ||
          doctor.specialty.toLowerCase().contains(query);
    }).toList(growable: false);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ConsultationUiConfig.pageTopGradient,
              ConsultationUiConfig.pageBottomGradient,
            ],
            stops: [0.09, 0.36],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              ConsultationScreenHeaderWidget(
                title: l10n.consultationSpecialistTitle,
                onBackTap: context.pop,
              ),
              ConsultationHeroBannerWidget(
                doctorImage: Image.asset(
                  ConsultationUiConfig.heroDoctorAsset,
                  width: 188.w,
                  height: 177.h,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(42.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 12.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ResultsSearchField(
                                controller: _searchController,
                                onChanged: (value) => setState(() => _query = value),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            ResultsFilterButton(textTheme: textTheme),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        ResultsDoctorCategoryCard(
                          category: _selectedCategory,
                          textTheme: textTheme,
                          onChangeTap: _openSelectCategoryDialog,
                        ),
                        SizedBox(height: 14.h),
                        Expanded(
                          child: _isLoading
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: List.generate(
                                      4,
                                      (index) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: index < 3 ? 10.h : 0,
                                        ),
                                        child: AppShimmerCard(
                                          height: 104.h,
                                          borderRadius: 12.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.zero,
                                  itemCount: doctors.length,
                                  separatorBuilder: (_, _) => SizedBox(height: 10.h),
                                  itemBuilder: (context, index) {
                                    return ResultsDoctorCard(
                                      doctor: doctors[index],
                                      textTheme: textTheme,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullScreenShimmer(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ConsultationUiConfig.pageTopGradient,
              ConsultationUiConfig.pageBottomGradient,
            ],
            stops: [0.09, 0.36],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              ConsultationScreenHeaderWidget(
                title: l10n.consultationSpecialistTitle,
                onBackTap: context.pop,
              ),
              ConsultationHeroBannerWidget(
                doctorImage: Image.asset(
                  ConsultationUiConfig.heroDoctorAsset,
                  width: 188.w,
                  height: 177.h,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(42.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 12.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppShimmerCard(
                                height: 48.h,
                                borderRadius: 11.r,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            AppShimmerCard(
                              width: 94.w,
                              height: 48.h,
                              borderRadius: 11.r,
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        AppShimmerCard(
                          height: 62.h,
                          borderRadius: 11.r,
                        ),
                        SizedBox(height: 14.h),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                4,
                                (index) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index < 3 ? 10.h : 0,
                                  ),
                                  child: AppShimmerCard(
                                    height: 104.h,
                                    borderRadius: 12.r,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
