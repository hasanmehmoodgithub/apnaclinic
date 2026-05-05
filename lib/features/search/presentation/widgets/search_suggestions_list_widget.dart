import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/search_entity.dart';
import 'search_highlighted_text_widget.dart';
import 'search_widget_utils.dart';

class SearchSuggestionsListWidget extends StatelessWidget {
  const SearchSuggestionsListWidget({
    super.key,
    required this.query,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  final String query;
  final List<SearchSuggestionEntity> suggestions;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 10.h),
            children: [
              Text(
                l10n.searchForQuery(query),
                style: TextStyle(
                  color: AppColors.clrBlack,
                  fontWeight: FontWeight.w800,
                  fontSize: 19.sp,
                ),
              ),
              SizedBox(height: 10.h),
              ...suggestions.map(
                (item) => InkWell(
                  onTap: () => onSuggestionTap(item.title),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.clrE3E3E3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.clrE3E3E3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              sectionIconAsset(item.sectionType),
                              width: 22.r,
                              height: 22.r,
                              colorFilter: const ColorFilter.mode(
                                AppColors.clr060,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SearchHighlightedTextWidget(
                                text: item.title,
                                highlight: query,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                item.subtitle,
                                style: TextStyle(
                                  color: AppColors.clr7B7979,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.north_west_rounded,
                          color: AppColors.clr5D758F,
                          size: 20.r,
                        ),
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
                backgroundColor: AppColors.clr0FAA9A,
                minimumSize: Size.fromHeight(56.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.r),
                ),
              ),
              child: Text(
                l10n.searchScreenTitle,
                style: TextStyle(
                  color: AppColors.clrWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
