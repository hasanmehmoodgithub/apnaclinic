import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/search_entity.dart';

class SearchInitialContentWidget extends StatelessWidget {
  const SearchInitialContentWidget({
    super.key,
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
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 24.h),
      children: [
        if (recent.isNotEmpty) ...[
          Text(
            l10n.searchRecentSearchesTitle,
            style: TextStyle(
              color: AppColors.clrBlack,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10.h),
          ...recent.map(
            (item) => InkWell(
              onTap: () => onRecentTap(item.title),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      color: AppColors.clr5D758F,
                      size: 22.r,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              color: AppColors.clrBlack,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (item.subtitle.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(
                              item.subtitle,
                              style: TextStyle(
                                color: AppColors.clr7B7979,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => onRemoveRecent(item.title),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Icon(
                          Icons.close,
                          color: AppColors.clr5D758F,
                          size: 18.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
        ],
        Text(
          l10n.searchPopularSearchesTitle,
          style: TextStyle(
            color: AppColors.clrBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
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
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.clrWhite,
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(color: AppColors.clrE4E4E4),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: AppColors.clr3D3D3D,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
