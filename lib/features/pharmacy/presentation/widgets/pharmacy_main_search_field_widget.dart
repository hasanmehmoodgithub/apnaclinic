import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Search input used by the pharmacy main panel.
class PharmacyMainSearchFieldWidget extends StatefulWidget {
  const PharmacyMainSearchFieldWidget({
    super.key,
    required this.searchQuery,
    required this.searchHint,
    required this.onSearchSubmitted,
  });

  final String searchQuery;
  final String searchHint;
  final ValueChanged<String> onSearchSubmitted;

  @override
  State<PharmacyMainSearchFieldWidget> createState() =>
      _PharmacyMainSearchFieldWidgetState();
}

class _PharmacyMainSearchFieldWidgetState
    extends State<PharmacyMainSearchFieldWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant PharmacyMainSearchFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != _controller.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.searchQuery,
        selection: TextSelection.collapsed(offset: widget.searchQuery.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch() {
    widget.onSearchSubmitted(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45.r,
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.searchHint,
          suffixIcon: IconButton(
            onPressed: _submitSearch,
            icon: const Icon(Icons.search, color: AppColors.clr9AA4B2),
          ),
          filled: true,
          fillColor: AppColors.clrWhite,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 14.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: AppColors.clrE3E8EE),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: AppColors.clrE3E8EE),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: AppColors.clr9EC7E8),
          ),
        ),
      ),
    );
  }
}
