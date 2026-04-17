import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/search_entity.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (_controller.text != state.query) {
          _controller.value = TextEditingValue(
            text: state.query,
            selection: TextSelection.collapsed(offset: state.query.length),
          );
        }

        return AppScaffoldGradient(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 13.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF061E40),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Search',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF061E40),
                          fontWeight: FontWeight.w700,
                          fontSize: 31.sp / 1.6,
                        ),
                      ),
                    ),
                    SizedBox(width: 40.w),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 0),
                        child: _SearchInputRow(
                          controller: _controller,
                          isListening: state.isListening,
                          onChanged: (value) =>
                              context.read<SearchCubit>().onQueryChanged(value),
                          onSubmit: (_) =>
                              context.read<SearchCubit>().submitSearch(_controller.text),
                          onClear: () => context.read<SearchCubit>().clearQuery(),
                          onMicTap: () {
                            if (state.isListening) {
                              context.read<SearchCubit>().stopListening();
                            } else {
                              context.read<SearchCubit>().startListening();
                            }
                          },
                          onSearchTap: () => context.read<SearchCubit>().submitSearch(
                                _controller.text,
                              ),
                        ),
                      ),
                      Expanded(
                        child: _buildBody(context, state),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    final query = state.query.trim();
    final hasSections = state.content.sections.isNotEmpty;
    final hasSuggestions = state.content.suggestions.isNotEmpty;
    final isInitial =
        query.isEmpty && !state.isSubmitted && !state.isListening && !hasSections;

    if (state.loadingStateStatus == StateStatus.loading) {
      return _SearchShimmerView(showResultsStyle: !isInitial);
    }

    if (state.loadingStateStatus == StateStatus.error) {
      return Center(
        child: Text(state.errorMessage ?? 'Failed to load search'),
      );
    }

    if (state.isSubmitted && hasSections) {
      return _SearchResultsSections(
        sections: state.content.sections,
        query: query,
      );
    }

    if (hasSuggestions) {
      return _SearchSuggestionsList(
        query: query,
        suggestions: state.content.suggestions,
        onSuggestionTap: (value) {
          context.read<SearchCubit>().submitSearch(value);
        },
      );
    }

    return _SearchInitialContent(
      recent: state.content.recentSearches,
      popular: state.content.popularSearches,
      onRemoveRecent: (title) =>
          context.read<SearchCubit>().removeRecentSearch(title),
      onPopularTap: (value) => context.read<SearchCubit>().submitSearch(value),
    );
  }
}

class _SearchShimmerView extends StatelessWidget {
  const _SearchShimmerView({required this.showResultsStyle});

  final bool showResultsStyle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(15.w, 16.h, 15.w, 20.h),
      children: [
        AppShimmerText(height: 22.h, width: 170.w, borderRadius: 6.r),
        SizedBox(height: 12.h),
        if (!showResultsStyle) ...[
          AppShimmer(
            layout: ShimmerLayout.list,
            direction: ShimmerDirection.vertical,
            itemCount: 3,
            spacing: 14.h,
            itemBuilder: (_, __) => Row(
              children: [
                AppShimmerCircle(diameter: 24.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerText(height: 16.h, width: 110.w, borderRadius: 5.r),
                      SizedBox(height: 6.h),
                      AppShimmerText(height: 14.h, width: 160.w, borderRadius: 5.r),
                    ],
                  ),
                ),
                AppShimmerCircle(diameter: 18.r),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          AppShimmerText(height: 22.h, width: 175.w, borderRadius: 6.r),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 8.h,
            children: List.generate(
              4,
              (_) => AppShimmerCard(
                width: 96.w,
                height: 38.h,
                borderRadius: 100.r,
              ),
            ),
          ),
        ] else ...[
          AppShimmer(
            layout: ShimmerLayout.list,
            direction: ShimmerDirection.vertical,
            itemCount: 3,
            spacing: 14.h,
            itemBuilder: (_, __) => Column(
              children: [
                AppShimmerCard(height: 48.h, borderRadius: 11.r),
                SizedBox(height: 8.h),
                AppShimmerCard(height: 136.h, borderRadius: 16.r),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SearchInputRow extends StatelessWidget {
  const _SearchInputRow({
    required this.controller,
    required this.isListening,
    required this.onChanged,
    required this.onSubmit,
    required this.onClear,
    required this.onMicTap,
    required this.onSearchTap,
  });

  final TextEditingController controller;
  final bool isListening;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmit;
  final VoidCallback onClear;
  final VoidCallback onMicTap;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasText = controller.text.trim().isNotEmpty;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 57.5.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE3E3E3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    onSubmitted: onSubmit,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: isListening
                          ? 'Listening...'
                          : 'Search Medicine, Doctor, Test...',
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFA1A1A1),
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                if (hasText)
                  InkWell(
                    onTap: onClear,
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 22.r,
                      color: Colors.black87,
                    ),
                  )
                else
                  InkWell(
                    onTap: onMicTap,
                    child: SvgPicture.asset(
                      Assets.svgIcSearchMic,
                      width: 20.r,
                      height: 20.r,
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap: onSearchTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            width: 57.5.r,
            height: 57.5.r,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE3E3E3)),
            ),
            child: Icon(
              Icons.search_rounded,
              color: const Color(0xFF061E40),
              size: 24.r,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchInitialContent extends StatelessWidget {
  const _SearchInitialContent({
    required this.recent,
    required this.popular,
    required this.onRemoveRecent,
    required this.onPopularTap,
  });

  final List<SearchRecentEntity> recent;
  final List<String> popular;
  final ValueChanged<String> onRemoveRecent;
  final ValueChanged<String> onPopularTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: EdgeInsets.fromLTRB(15.w, 17.h, 15.w, 24.h),
      children: [
        Text(
          'Recent Searches',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        ...recent.map(
          (item) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: const Color(0xFF5D758F),
                  size: 24.r,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        item.subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF7B7979),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => onRemoveRecent(item.title),
                  child: Icon(Icons.close, color: const Color(0xFF5D758F), size: 20.r),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          'Popular Searches',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 4.w,
          runSpacing: 4.h,
          children: popular
              .map(
                (item) => ActionChip(
                  onPressed: () => onPopularTap(item),
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(
                    side: const BorderSide(color: Color(0xFFE4E4E4)),
                  ),
                  label: Text(
                    item,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF3D3D3D),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SearchSuggestionsList extends StatelessWidget {
  const _SearchSuggestionsList({
    required this.query,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  final String query;
  final List<SearchSuggestionEntity> suggestions;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 10.h),
            children: [
              Text(
                'Search for "$query"',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 30.sp / 1.6,
                ),
              ),
              SizedBox(height: 10.h),
              ...suggestions.map(
                (item) => InkWell(
                  onTap: () => onSuggestionTap(item.title),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFE3E3E3))),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42.r,
                          height: 42.r,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE3E3E3)),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Icon(_sectionIcon(item.sectionType))),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                item.subtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF7B7979),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.north_west_rounded, color: const Color(0xFF5D758F)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15.w, 6.h, 15.w, 12.h),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => onSuggestionTap(query),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1FAFA3),
                minimumSize: Size.fromHeight(57.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Text(
                'Search',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchResultsSections extends StatelessWidget {
  const _SearchResultsSections({
    required this.sections,
    required this.query,
  });

  final List<SearchSectionEntity> sections;
  final String query;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(15.w, 14.h, 15.w, 16.h),
      children: sections
          .map((section) => _SectionBlock(section: section, query: query))
          .toList(),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.section,
    required this.query,
  });

  final SearchSectionEntity section;
  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE3E3E3)),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(_sectionIcon(section.type), size: 18.r)),
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: Text(
                    section.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
                Text(
                  'See All',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          ...section.results.map(
            (item) => switch (section.type) {
              SearchSectionType.doctorConsultation || SearchSectionType.surgeryBooking =>
                _DoctorResultCard(
                  item: item,
                  showHospital: section.type == SearchSectionType.surgeryBooking,
                ),
              SearchSectionType.pharmacy => _PharmacyResultCard(item: item),
              SearchSectionType.laboratoryTests => _LabResultCard(item: item),
            },
          ),
        ],
      ),
    );
  }
}

class _DoctorResultCard extends StatelessWidget {
  const _DoctorResultCard({
    required this.item,
    required this.showHospital,
  });

  final SearchResultEntity item;
  final bool showHospital;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9.r),
            child: Image.asset(
              Assets.imgPlaceHolderPerson,
              width: 102.r,
              height: 126.r,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                  ),
                ),
                Text(
                  item.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF667B99),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.description ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF667B99),
                  ),
                ),
                if (showHospital && (item.hospital?.isNotEmpty ?? false)) ...[
                  SizedBox(height: 4.h),
                  Text(
                    item.hospital!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667B99),
                    ),
                  ),
                ],
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fee',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF667B99),
                          ),
                        ),
                        Text(
                          item.fee ?? 'Rs. 800/-',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF110844),
                          ),
                        ),
                      ],
                    ),
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0FAFA0),
                        minimumSize: Size(96.w, 44.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        item.primaryActionLabel ?? 'Book Now',
                        style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PharmacyResultCard extends StatelessWidget {
  const _PharmacyResultCard({required this.item});

  final SearchResultEntity item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 130.r,
            height: 88.r,
            decoration: BoxDecoration(
              color: const Color(0xFFE6EDF1),
              borderRadius: BorderRadius.circular(9.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              Assets.servicesPharmacy,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 28.sp / 1.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  item.price ?? item.subtitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LabResultCard extends StatelessWidget {
  const _LabResultCard({required this.item});

  final SearchResultEntity item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 122.r,
            height: 142.r,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Icon(Icons.biotech_outlined, size: 44.r, color: const Color(0xFF5D758F)),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF667B99),
                  ),
                ),
                Text(
                  item.description ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF667B99),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      'Sample Type',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF667B99),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE7E7E7)),
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Text(
                        item.sampleType ?? 'Blood',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF667B99),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fee',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF667B99),
                          ),
                        ),
                        Text(
                          item.fee ?? 'Rs. 15,000/-',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF110844),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDEF8FB),
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Text(
                        item.providerLabel ?? 'Provided By Oladoc',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF0590A0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

IconData _sectionIcon(SearchSectionType type) {
  switch (type) {
    case SearchSectionType.doctorConsultation:
      return Icons.medical_services_rounded;
    case SearchSectionType.pharmacy:
      return Icons.medication_outlined;
    case SearchSectionType.laboratoryTests:
      return Icons.science_outlined;
    case SearchSectionType.surgeryBooking:
      return Icons.vaccines_outlined;
  }
}
