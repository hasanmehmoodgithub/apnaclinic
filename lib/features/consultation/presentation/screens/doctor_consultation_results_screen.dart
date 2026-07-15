import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/router/app_routes.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/consultation_category_entity.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../domain/use_cases/get_consultation_categories_use_case.dart';
import '../../domain/use_cases/get_consultation_doctors_use_case.dart';
import '../constants/consultation_ui_config.dart';
import '../widgets/results_doctor_card.dart';
import '../widgets/results_doctor_category_card.dart';
import '../widgets/results_doctor_item.dart';
import '../widgets/results_filter_button.dart';
import '../widgets/results_search_field.dart';
import '../widgets/consultation_select_partner_sheet_widget.dart';
import '../constants/consultation_partner_filter_defaults.dart';
import '../widgets/results_select_categories_dialog.dart';
import '../widgets/consultation_screen_header_widget.dart';
import '../widgets/consultation_hero_banner_widget.dart';
import '../doctor_consultation_book_doctor_args.dart';

class DoctorConsultationResultsScreen extends StatefulWidget {
  final String selectedCategory;
  final String mainCategoryId;
  final List<ConsultationCategoryEntity> categoryOptions;

  const DoctorConsultationResultsScreen({
    super.key,
    required this.selectedCategory,
    required this.mainCategoryId,
    this.categoryOptions = const [],
  });

  @override
  State<DoctorConsultationResultsScreen> createState() =>
      _DoctorConsultationResultsScreenState();
}

class _DoctorConsultationResultsScreenState
    extends State<DoctorConsultationResultsScreen> {
  final GetConsultationCategoriesUseCase _getCategoriesUseCase =
      sl<GetConsultationCategoriesUseCase>();
  final GetConsultationDoctorsUseCase _getDoctorsUseCase =
      sl<GetConsultationDoctorsUseCase>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ConsultationCategoryEntity> _categoryOptions = const [];

  static const int _pageLimit = 20;

  List<ResultsDoctorItem> _allDoctors = const [];
  List<ConsultationPartnerFilterOption> _filterPartners =
      ConsultationPartnerFilterDefaults.partners;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  int _currentPage = 1;
  String _query = '';
  String? _selectedPartnerId;
  late String _selectedCategory;
  late String _mainCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _mainCategoryId = widget.mainCategoryId;
    _categoryOptions = widget.categoryOptions;
    if (_categoryOptions.isEmpty) {
      _loadCategories();
    }
    _scrollController.addListener(_onScroll);
    _loadDoctors(refresh: true);
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        _isLoading ||
        _isLoadingMore ||
        !_hasMore) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadMoreDoctors();
    }
  }

  void _onSearchSubmitted() {
    final value = _searchController.text.trim();
    if (_query == value) {
      if (value.isEmpty) return;
      _loadDoctors(refresh: true);
      return;
    }
    setState(() => _query = value);
    _loadDoctors(refresh: true);
  }

  void _onSearchCleared() {
    if (_searchController.text.isEmpty && _query.isEmpty) return;
    _searchController.clear();
    setState(() => _query = '');
    _loadDoctors(refresh: true);
  }

  Future<void> _loadCategories() async {
    final result = await _getCategoriesUseCase();
    if (!mounted) return;
    result.fold(
      (_) {},
      (categories) => setState(() => _categoryOptions = categories),
    );
  }

  Future<void> _openSelectCategoryDialog() async {
    if (_categoryOptions.isEmpty) {
      await _loadCategories();
    }
    if (!mounted) return;
    final category = await showDialog<ConsultationCategoryEntity>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (context) => ResultsSelectCategoriesDialog(
        selectedCategory: _selectedCategory,
        categories: _categoryOptions,
      ),
    );
    if (category == null ||
        category.title == _selectedCategory &&
            category.id == _mainCategoryId) {
      return;
    }
    setState(() {
      _selectedCategory = category.title;
      _mainCategoryId = category.id;
    });
    await _loadDoctors(refresh: true);
  }

  void _onBookNowTap(ResultsDoctorItem doctor) {
    if (!context.requireLogin()) return;
    context.pushNamed(
      AppRoutes.consultationBookDoctor,
      extra: DoctorConsultationBookDoctorArgs(doctor: doctor),
    );
  }

  Future<void> _openSelectPartnerSheet() async {
    final result = await showModalBottomSheet<Object?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConsultationSelectPartnerSheetWidget(
        selectedPartnerId: _selectedPartnerId,
        partners: _filterPartners,
      ),
    );
    if (!mounted || result == null) return;

    if (result == ConsultationSelectPartnerSheetWidget.clearSelection) {
      if (_selectedPartnerId == null) return;
      setState(() => _selectedPartnerId = null);
      await _loadDoctors(refresh: true);
      return;
    }

    if (result is! ConsultationPartnerFilterOption) return;
    if (result.id == _selectedPartnerId) return;
    setState(() => _selectedPartnerId = result.id);
    await _loadDoctors(refresh: true);
  }

  Future<void> _loadDoctors({required bool refresh}) async {
    if (refresh) {
      setState(() {
        _isLoading = _allDoctors.isEmpty;
        _isLoadingMore = false;
        _hasMore = false;
        _currentPage = 1;
      });
      await _fetchDoctors(page: 1, append: false);
      return;
    }

    setState(() => _isLoading = true);
    await _fetchDoctors(page: 1, append: false);
  }

  Future<void> _loadMoreDoctors() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    await _fetchDoctors(page: _currentPage + 1, append: true);
  }

  Future<void> _fetchDoctors({
    required int page,
    required bool append,
  }) async {
    final trimmedSearch = _query.trim();
    final result = await _getDoctorsUseCase(
      GetConsultationDoctorsParams(
        mainCategoryId: _mainCategoryId,
        partnerId: _selectedPartnerId,
        search: trimmedSearch.isEmpty ? null : trimmedSearch,
        page: page,
        limit: _pageLimit,
      ),
    );
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        if (!append) _allDoctors = const [];
        _isLoading = false;
        _isLoadingMore = false;
        _hasMore = false;
      }),
      (pageData) => setState(() {
        _allDoctors =
            append ? [..._allDoctors, ...pageData.doctors] : pageData.doctors;
        if (!append && pageData.partners.isNotEmpty) {
          _filterPartners = pageData.partners;
          final selected = _selectedPartnerId;
          if (selected != null &&
              !_filterPartners.any((partner) => partner.id == selected)) {
            _selectedPartnerId = null;
          }
        }
        _currentPage = pageData.page;
        _hasMore = pageData.hasMore;
        _isLoading = false;
        _isLoadingMore = false;
      }),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading && _allDoctors.isEmpty) {
      return _buildFullScreenShimmer(context);
    }

    final textTheme = Theme.of(context).textTheme;
    final doctors = _allDoctors;

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
                                showClear: _query.trim().isNotEmpty,
                                onSearch: _onSearchSubmitted,
                                onClear: _onSearchCleared,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            ResultsFilterButton(
                              textTheme: textTheme,
                              label: l10n.consultationResultsFilter,
                              isActive: _selectedPartnerId != null,
                              onTap: _openSelectPartnerSheet,
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Expanded(
                          child: ListView(
                            controller: _scrollController,
                            padding: EdgeInsets.zero,
                            children: [
                              ResultsDoctorCategoryCard(
                                category: _selectedCategory,
                                textTheme: textTheme,
                                onChangeTap: _openSelectCategoryDialog,
                              ),
                              SizedBox(height: 14.h),
                              if (doctors.isEmpty && !_isLoading)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.h),
                                  child: Center(
                                    child: Text(
                                      l10n.consultationNoDoctorsFound,
                                      textAlign: TextAlign.center,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: const Color(0xFF667B99),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                for (var index = 0; index < doctors.length; index++) ...[
                                  if (index > 0) SizedBox(height: 10.h),
                                  ResultsDoctorCard(
                                    doctor: doctors[index],
                                    textTheme: textTheme,
                                    onBookNowTap: () => _onBookNowTap(doctors[index]),
                                  ),
                                ],
                              if (_isLoadingMore) ...[
                                SizedBox(height: 16.h),
                                const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ],
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
