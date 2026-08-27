import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/no_emoji_text_input_formatter.dart';
import '../../../../generated/assets.dart';
import 'search_voice_listening_lottie.dart';

class SearchInputRowWidget extends StatelessWidget {
  const SearchInputRowWidget({
    super.key,
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
    final l10n = AppLocalizations.of(context)!;
    final hasText = controller.text.trim().isNotEmpty;
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.clrE3E3E3),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              inputFormatters: NoEmojiTextInputFormatter.merge(
                null,
                allowSpecialCharacters: true,
              ),
              onChanged: onChanged,
              onSubmitted: onSubmit,
              textInputAction: TextInputAction.search,
              cursorColor: AppColors.clr060,
              style: TextStyle(
                color: AppColors.clrBlack,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: isListening
                    ? l10n.searchListeningHint
                    : l10n.dashboardSearchHint,
                hintStyle: TextStyle(
                  color: AppColors.clrA1A1A1,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (isListening) ...[
            InkWell(
              onTap: onMicTap,
              borderRadius: BorderRadius.circular(20.r),
              child: SearchVoiceListeningLottie(size: 36.r),
            ),
            SizedBox(width: 8.w),
          ] else if (hasText) ...[
            InkWell(
              onTap: onClear,
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(2.r),
                child: Icon(
                  Icons.cancel_outlined,
                  size: 22.r,
                  color: AppColors.clr060,
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ] else ...[
            InkWell(
              onTap: onMicTap,
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(2.r),
                child: SvgPicture.asset(
                  Assets.svgIcSearchMic,
                  width: 20.r,
                  height: 20.r,
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          InkWell(
            onTap: onSearchTap,
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(2.r),
              child: Icon(Icons.search, color: AppColors.clr060, size: 22.r),
            ),
          ),
        ],
      ),
    );
  }
}
