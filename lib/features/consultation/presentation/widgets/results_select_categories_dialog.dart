import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/consultation_category_entity.dart';

class ResultsSelectCategoriesDialog extends StatelessWidget {
  const ResultsSelectCategoriesDialog({
    super.key,
    required this.selectedCategory,
    required this.categories,
  });

  final String selectedCategory;
  final List<ConsultationCategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 44.h),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.consultationSelectCategoriesTitle,
                      style: textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF2A3441),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(14.r),
                    onTap: () => context.pop(),
                    child: Padding(
                      padding: EdgeInsets.all(2.r),
                      child: Icon(
                        Icons.close_rounded,
                        color: const Color(0xFF7E8898),
                        size: 21.r,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF0F1F3)),
              SizedBox(height: 6.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: categories.map((category) {
                      final label = category.cardTitle;
                      final isSelected = category.title == selectedCategory ||
                          label == selectedCategory;
                      return InkWell(
                        onTap: () => context.pop(category),
                        borderRadius: BorderRadius.circular(7.r),
                        child: Container(
                          height: 42.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFF4F5F7)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF3B4756),
                                    fontSize: 12.8.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: const Color(0xFF5D6777),
                                size: 18.r,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(growable: false),
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
