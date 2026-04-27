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

// search_screen.dart
//
// Pixel-accurate rebuild of the Search screen to match the provided
// screenshots. Keep your existing imports (flutter_bloc, flutter_screenutil,
// flutter_svg, your Assets, entities, cubit, and AppScaffoldGradient).
//
// Design tokens used (colors sampled from the screenshots):
//   Navy (titles / back arrow)     #061E40
//   Subtle navy (labels)           #5D758F
//   Body grey (secondary text)     #7B7979 / #667B99
//   Divider / stroke               #E3E3E3 / #E7E7E7
//   Card / chip stroke             #E4E4E4
//   Section pill background        #F7F7F7
//   Pharmacy image background      #E8F0F5
//   Lab image background           #F4F4F4
//   Provided-by pill background    #DEF8FB  (text #0590A0)
//   Primary teal (buttons)         #0FAFA0
//   Rating badge stroke            #0FAFA0 (with very light fill)
//
// Typography: relies on your app theme. All sizes are specified explicitly
// using .sp so the hierarchy is consistent.

// search_screen.dart
//
// Pixel-accurate rebuild of the Search screen to match the provided
// screenshots. Keep your existing imports (flutter_bloc, flutter_screenutil,
// flutter_svg, your Assets, entities, cubit, and AppScaffoldGradient).
//
// Design tokens used (colors sampled from the screenshots):
//   Navy (titles / back arrow)     #061E40
//   Subtle navy (labels)           #5D758F
//   Body grey (secondary text)     #7B7979 / #667B99
//   Divider / stroke               #E3E3E3 / #E7E7E7
//   Card / chip stroke             #E4E4E4
//   Section pill background        #F7F7F7
//   Pharmacy image background      #E8F0F5
//   Lab image background           #F4F4F4
//   Provided-by pill background    #DEF8FB  (text #0590A0)
//   Primary teal (buttons)         #0FAFA0
//   Rating badge stroke            #0FAFA0 (with very light fill)
//
// Typography: relies on your app theme. All sizes are specified explicitly
// using .sp so the hierarchy is consistent.

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
  const SearchScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _didSubmitInitialQuery = false;

  @override
  void initState() {
    super.initState();
    final seed = widget.initialQuery?.trim() ?? '';
    if (seed.isNotEmpty) {
      _controller.text = seed;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _didSubmitInitialQuery = true;
        context.read<SearchCubit>().submitSearch(seed);
      });
    } else {
      _didSubmitInitialQuery = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (_didSubmitInitialQuery && _controller.text != state.query) {
          _controller.value = TextEditingValue(
            text: state.query,
            selection: TextSelection.collapsed(offset: state.query.length),
          );
        }

        return AppScaffoldGradient(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 18.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(Icons.arrow_back_rounded,
                          color: const Color(0xFF061E40), size: 26.r),
                    ),
                    Expanded(
                      child: Text('Search',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color(0xFF061E40),
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp)),
                    ),
                    SizedBox(width: 44.w),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(28.r)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                        child: _SearchInputRow(
                          controller: _controller,
                          isListening: state.isListening,
                          onChanged: (v) =>
                              context.read<SearchCubit>().onQueryChanged(v),
                          onSubmit: (_) => context
                              .read<SearchCubit>()
                              .submitSearch(_controller.text),
                          onClear: () =>
                              context.read<SearchCubit>().clearQuery(),
                          onMicTap: () {
                            if (state.isListening) {
                              context.read<SearchCubit>().stopListening();
                            } else {
                              context.read<SearchCubit>().startListening();
                            }
                          },
                          onSearchTap: () => context
                              .read<SearchCubit>()
                              .submitSearch(_controller.text),
                        ),
                      ),
                      Expanded(child: _buildBody(context, state)),
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
    final isInitial = query.isEmpty &&
        !state.isSubmitted &&
        !state.isListening &&
        !hasSections;

    if (state.loadingStateStatus == StateStatus.loading) {
      return _SearchShimmerView(showResultsStyle: !isInitial);
    }
    if (state.loadingStateStatus == StateStatus.error) {
      return Center(child: Text(state.errorMessage ?? 'Failed to load search'));
    }
    if (state.isSubmitted && hasSections) {
      return _SearchResultsSections(
          sections: state.content.sections, query: query);
    }
    if (hasSuggestions) {
      return _SearchSuggestionsList(
        query: query,
        suggestions: state.content.suggestions,
        onSuggestionTap: (v) => context.read<SearchCubit>().submitSearch(v),
      );
    }
    return _SearchInitialContent(
      recent: state.content.recentSearches,
      popular: state.content.popularSearches,
      onRecentTap: (t) => context.read<SearchCubit>().submitSearch(t),
      onRemoveRecent: (t) =>
          context.read<SearchCubit>().removeRecentSearch(t),
      onPopularTap: (v) => context.read<SearchCubit>().submitSearch(v),
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
    final hasText = controller.text.trim().isNotEmpty;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
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
                    textInputAction: TextInputAction.search,
                    cursorColor: const Color(0xFF061E40),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: isListening
                          ? 'Listening...'
                          : 'Search Medicine, Doctor, Test...',
                      hintStyle: TextStyle(
                          color: const Color(0xFFA1A1A1),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                if (hasText)
                  InkWell(
                    onTap: onClear,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Padding(
                      padding: EdgeInsets.all(2.r),
                      child: Icon(Icons.cancel_outlined,
                          size: 22.r, color: const Color(0xFF061E40)),
                    ),
                  )
                else
                  InkWell(
                    onTap: onMicTap,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Padding(
                      padding: EdgeInsets.all(2.r),
                      child: SvgPicture.asset(Assets.svgIcSearchMic,
                          width: 20.r, height: 20.r),
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
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE3E3E3)),
            ),
            child: Icon(Icons.search,
                color: const Color(0xFF061E40), size: 22.r),
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
    required this.onRecentTap,
    required this.onRemoveRecent,
    required this.onPopularTap,
  });

  final List<SearchRecentEntity> recent;
  final List<String> popular;
  final ValueChanged<String> onRecentTap;
  final ValueChanged<String> onRemoveRecent;
  final ValueChanged<String> onPopularTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 24.h),
      children: [
        if (recent.isNotEmpty) ...[
          Text('Recent Searches',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800)),
          SizedBox(height: 10.h),
          ...recent.map(
                (item) => InkWell(
              onTap: () => onRecentTap(item.title),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  children: [
                    Icon(Icons.history_rounded,
                        color: const Color(0xFF5D758F), size: 22.r),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w800)),
                          if (item.subtitle.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(item.subtitle,
                                style: TextStyle(
                                    color: const Color(0xFF7B7979),
                                    fontSize: 13.sp)),
                          ],
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => onRemoveRecent(item.title),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Icon(Icons.close,
                            color: const Color(0xFF5D758F), size: 18.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
        ],
        Text('Popular Searches',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800)),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 10.h,
          children: popular
              .map(
                (item) => InkWell(
              onTap: () => onPopularTap(item),
              borderRadius: BorderRadius.circular(100.r),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(color: const Color(0xFFE4E4E4)),
                ),
                child: Text(item,
                    style: TextStyle(
                        color: const Color(0xFF3D3D3D),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500)),
              ),
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
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 10.h),
            children: [
              Text('Search for "$query"',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 19.sp)),
              SizedBox(height: 10.h),
              ...suggestions.map(
                    (item) => InkWell(
                  onTap: () => onSuggestionTap(item.title),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.w, vertical: 12.h),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xFFE3E3E3))),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: const Color(0xFFE3E3E3)),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              _sectionIconAsset(item.sectionType),
                              width: 22.r,
                              height: 22.r,
                              colorFilter: const ColorFilter.mode(
                                  Color(0xFF061E40), BlendMode.srcIn),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _HighlightedText(
                                  text: item.title, highlight: query),
                              SizedBox(height: 2.h),
                              Text(item.subtitle,
                                  style: TextStyle(
                                      color: const Color(0xFF7B7979),
                                      fontSize: 13.sp)),
                            ],
                          ),
                        ),
                        Icon(Icons.north_west_rounded,
                            color: const Color(0xFF5D758F), size: 20.r),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 16.h),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => onSuggestionTap(query),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0FAFA0),
                minimumSize: Size.fromHeight(56.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.r)),
              ),
              child: Text('Search',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp)),
            ),
          ),
        ),
      ],
    );
  }
}

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({required this.text, required this.highlight});
  final String text;
  final String highlight;

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
        color: Colors.black,
        fontSize: 15.sp,
        fontWeight: FontWeight.w500);
    final bold = base.copyWith(fontWeight: FontWeight.w800);
    if (highlight.isEmpty) return Text(text, style: bold);
    final lower = text.toLowerCase();
    final needle = highlight.toLowerCase();
    final idx = lower.indexOf(needle);
    if (idx == -1) return Text(text, style: bold);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text.substring(0, idx), style: bold),
          TextSpan(
              text: text.substring(idx, idx + highlight.length),
              style: base),
          TextSpan(text: text.substring(idx + highlight.length), style: bold),
        ],
      ),
    );
  }
}

class _SearchResultsSections extends StatelessWidget {
  const _SearchResultsSections(
      {required this.sections, required this.query});
  final List<SearchSectionEntity> sections;
  final String query;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
      children: sections
          .map((s) => _SectionBlock(section: s, query: query))
          .toList(),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.section, required this.query});
  final SearchSectionEntity section;
  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeaderPill(
              title: section.title,
              iconAsset: _sectionIconAsset(section.type)),
          SizedBox(height: 12.h),
          ...section.results.map(
                (item) => switch (section.type) {
              SearchSectionType.doctorConsultation =>
                  _DoctorResultCard(item: item, showHospital: false),
              SearchSectionType.surgeryBooking =>
                  _DoctorResultCard(item: item, showHospital: true),
              SearchSectionType.pharmacy => _PharmacyResultCard(item: item),
              SearchSectionType.laboratoryTests => _LabResultCard(item: item),
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeaderPill extends StatelessWidget {
  const _SectionHeaderPill({required this.title, required this.iconAsset});
  final String title;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE3E3E3)),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                iconAsset,
                width: 18.r,
                height: 18.r,
                colorFilter: const ColorFilter.mode(
                    Color(0xFF061E40), BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(title,
                style: TextStyle(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp)),
          ),
          Text('See All',
              style: TextStyle(
                  color: const Color(0xFF3D3D3D),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _DoctorResultCard extends StatelessWidget {
  const _DoctorResultCard(
      {required this.item, required this.showHospital});
  final SearchResultEntity item;
  final bool showHospital;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(Assets.imgPlaceHolderPerson,
                width: 96.r, height: 132.r, fit: BoxFit.cover),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: const Color(0xFF061E40),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              _RatingBadge(rating: item.rating ?? '4 / 5'),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(item.subtitle,
                              style: TextStyle(
                                  color: const Color(0xFF667B99),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    if (item.providerLogo != null)
                      Container(
                        width: 38.r,
                        height: 38.r,
                        margin: EdgeInsets.only(left: 6.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: const Color(0xFFE3E3E3)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(item.providerLogo!,
                            fit: BoxFit.contain),
                      ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(item.description ?? '6 years Experience   MMBS, FCPS',
                    style: TextStyle(
                        color: const Color(0xFF667B99), fontSize: 12.sp)),
                SizedBox(height: 8.h),
                if (!showHospital)
                  Row(
                    children: [
                      _OutlinePill(text: item.date ?? '10/09/24'),
                      SizedBox(width: 6.w),
                      _OutlinePill(text: item.time ?? '1pm - 2pm'),
                    ],
                  )
                else if (item.hospital?.isNotEmpty ?? false)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                    child: Text(item.hospital!,
                        style: TextStyle(
                            color: const Color(0xFF667B99),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500)),
                  ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fee',
                              style: TextStyle(
                                  color: const Color(0xFF667B99),
                                  fontSize: 12.sp)),
                          SizedBox(height: 2.h),
                          Text(item.fee ?? 'Rs. 800/-',
                              style: TextStyle(
                                  color: const Color(0xFF110844),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0FAFA0),
                        minimumSize: Size(80.w, 35.h),
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text(item.primaryActionLabel ?? 'Book Now',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700)),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            width: 128.r,
            height: 90.r,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0F5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: Image.asset(Assets.servicesPharmacy, fit: BoxFit.contain),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.title,
                    style: TextStyle(
                        color: const Color(0xFF061E40),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 4.h),
                Text(item.price ?? item.subtitle,
                    style: TextStyle(
                        color: const Color(0xFF061E40),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500)),
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
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 118.r,
            height: 142.r,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: item.labLogo != null
                ? Image.asset(item.labLogo!, width: 72.r, fit: BoxFit.contain)
                : Icon(Icons.biotech_outlined,
                size: 44.r, color: const Color(0xFF5D758F)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(item.title,
                          style: TextStyle(
                              color: const Color(0xFF061E40),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700)),
                    ),
                    if (item.providerLogo != null)
                      SizedBox(
                        width: 46.r,
                        height: 18.r,
                        child: Image.asset(item.providerLogo!,
                            fit: BoxFit.contain),
                      ),
                  ],
                ),
                if (item.subtitle.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(item.subtitle,
                      style: TextStyle(
                          color: const Color(0xFF667B99), fontSize: 12.sp)),
                ],
                if ((item.description ?? '').isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(item.description!,
                        style: TextStyle(
                            color: const Color(0xFF667B99),
                            fontSize: 12.sp)),
                  ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text('Sample Type',
                        style: TextStyle(
                            color: const Color(0xFF667B99),
                            fontSize: 12.sp)),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        border:
                        Border.all(color: const Color(0xFFE7E7E7)),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(item.sampleType ?? 'Blood',
                          style: TextStyle(
                              color: const Color(0xFF3D3D3D),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500)),
                    ),
                    const Spacer(),
                    Icon(Icons.check_box_outline_blank_rounded,
                        size: 18.r, color: const Color(0xFFB5B5B5)),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fee',
                              style: TextStyle(
                                  color: const Color(0xFF667B99),
                                  fontSize: 12.sp)),
                          SizedBox(height: 2.h),
                          Text(item.fee ?? 'Rs. 15,000/-',
                              style: TextStyle(
                                  color: const Color(0xFF110844),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDEF8FB),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(item.providerLabel ?? 'Provided By Oladoc',
                          style: TextStyle(
                              color: const Color(0xFF0590A0),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600)),
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

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});
  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFBF6),
        border: Border.all(color: const Color(0xFF0FAFA0)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(rating,
          style: TextStyle(
              color: const Color(0xFF0FAFA0),
              fontSize: 11.sp,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _OutlinePill extends StatelessWidget {
  const _OutlinePill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE3E3E3)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(text,
          style: TextStyle(
              color: const Color(0xFF667B99),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500)),
    );
  }
}

class _SearchShimmerView extends StatelessWidget {
  const _SearchShimmerView({required this.showResultsStyle});
  final bool showResultsStyle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 20.h),
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
                      AppShimmerText(
                          height: 16.h, width: 110.w, borderRadius: 5.r),
                      SizedBox(height: 6.h),
                      AppShimmerText(
                          height: 14.h, width: 160.w, borderRadius: 5.r),
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
            spacing: 8.w,
            runSpacing: 10.h,
            children: List.generate(
              4,
                  (_) => AppShimmerCard(
                  width: 96.w, height: 38.h, borderRadius: 100.r),
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
                AppShimmerCard(height: 48.h, borderRadius: 12.r),
                SizedBox(height: 8.h),
                AppShimmerCard(height: 142.h, borderRadius: 16.r),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

String _sectionIconAsset(SearchSectionType type) {
  switch (type) {
    case SearchSectionType.doctorConsultation:
      return 'assets/icons/doctor.svg';
    case SearchSectionType.pharmacy:
      return 'assets/icons/pharmacy.svg';
    case SearchSectionType.laboratoryTests:
      return 'assets/icons/test.svg';
    case SearchSectionType.surgeryBooking:
      return 'assets/icons/booking.svg';
  }
}
