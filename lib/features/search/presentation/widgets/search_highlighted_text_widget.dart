import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class SearchHighlightedTextWidget extends StatelessWidget {
  const SearchHighlightedTextWidget({
    super.key,
    required this.text,
    required this.highlight,
  });

  final String text;
  final String highlight;

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      color: AppColors.clrBlack,
      fontSize: 15.sp,
      fontWeight: FontWeight.w500,
    );
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
            style: base,
          ),
          TextSpan(text: text.substring(idx + highlight.length), style: bold),
        ],
      ),
    );
  }
}
