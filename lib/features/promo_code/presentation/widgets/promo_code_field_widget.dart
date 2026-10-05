import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/no_emoji_text_input_formatter.dart';
import '../cubit/promo_code_state.dart';

class PromoCodeFieldWidget extends StatefulWidget {
  /// Checkout action buttons call this on pointer-down so that tap does not
  /// apply the code. Keyboard Done still calls [onSubmitted].
  static var _ignoreNextSubmit = false;

  static void ignoreNextSubmit() {
    _ignoreNextSubmit = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ignoreNextSubmit = false;
    });
  }

  const PromoCodeFieldWidget({
    super.key,
    required this.status,
    required this.displayCode,
    required this.onSubmitted,
    required this.onCleared,
    this.onChanged,
    this.enabled = true,
  });

  final PromoCodeStatus status;
  final String displayCode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onCleared;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  State<PromoCodeFieldWidget> createState() => _PromoCodeFieldWidgetState();
}

class _PromoCodeFieldWidgetState extends State<PromoCodeFieldWidget> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  bool get _showsChip =>
      widget.status == PromoCodeStatus.applied ||
      widget.status == PromoCodeStatus.invalid;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.displayCode);
  }

  @override
  void didUpdateWidget(covariant PromoCodeFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_showsChip &&
        oldWidget.status != PromoCodeStatus.idle &&
        widget.status == PromoCodeStatus.idle &&
        _controller.text.isNotEmpty) {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    if (_showsChip) {
      return Container(
        height: 48.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColors.clrPromoCodeBorder),
        ),
        child: _PromoCodeChip(
          code: widget.displayCode,
          onCleared: widget.enabled ? widget.onCleared : null,
        ),
      );
    }

    final isValidating = widget.status == PromoCodeStatus.validating;

    return SizedBox(
      height: 48.h,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled && !isValidating,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: NoEmojiTextInputFormatter.merge(
          [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]'))],
        ),
        onChanged: widget.onChanged,
        onSubmitted: (value) {
          if (PromoCodeFieldWidget._ignoreNextSubmit) return;
          final code = value.trim();
          if (code.isEmpty) return;
          _focusNode.unfocus();
          widget.onSubmitted(code);
        },
        style: textTheme.bodyMedium?.copyWith(
          color: AppColors.clr061E40,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: l10n.promoCodeHint,
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: AppColors.clr8A97A8,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: AppColors.clrWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
          suffixIcon: isValidating
              ? Padding(
                  padding: EdgeInsets.all(12.r),
                  child: SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null,
          border: _border(AppColors.clrPromoCodeBorder),
          enabledBorder: _border(AppColors.clrPromoCodeBorder),
          disabledBorder: _border(AppColors.clrPromoCodeBorder),
          focusedBorder: _border(AppColors.clr1FAFA3),
        ),
      ),
    );
  }
}

class _PromoCodeChip extends StatelessWidget {
  const _PromoCodeChip({
    required this.code,
    required this.onCleared,
  });

  final String code;
  final VoidCallback? onCleared;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 34.h,
      padding: EdgeInsets.only(left: 12.w, right: 4.w),
      decoration: BoxDecoration(
        color: AppColors.clrF4F4F4,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.clr7A7A7A,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            onPressed: onCleared,
            tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tightFor(width: 28.w, height: 28.h),
            icon: Icon(
              Icons.close,
              size: 16.r,
              color: AppColors.clr7A7A7A,
            ),
          ),
        ],
      ),
    );
  }
}
