import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'search_voice_listening_lottie.dart';

class SearchVoiceListeningView extends StatelessWidget {
  const SearchVoiceListeningView({super.key, this.onStop});

  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onStop,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchVoiceListeningLottie(size: 168.r),
            SizedBox(height: 8.h),
            Text(
              l10n.searchListeningHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.clr667085,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
