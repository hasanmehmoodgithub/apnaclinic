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
    required this.onSearchCleared,
  });

  final String searchQuery;
  final String searchHint;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onSearchCleared;

  @override
  State<PharmacyMainSearchFieldWidget> createState() =>
      _PharmacyMainSearchFieldWidgetState();
}

class _PharmacyMainSearchFieldWidgetState
    extends State<PharmacyMainSearchFieldWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
    _focusNode = FocusNode();
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
    _focusNode.dispose();
    super.dispose();
  }

  void _submitSearch() {
    widget.onSearchSubmitted(_controller.text);
  }

  void _clearSearch() {
    if (_controller.text.isEmpty && widget.searchQuery.isEmpty) return;
    _controller.clear();
    widget.onSearchCleared();
  }

  @override
  Widget build(BuildContext context) {
    // Clear only after a search has been submitted (active query in state).
    final hasActiveSearch = widget.searchQuery.trim().isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 45.r,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (_) => _submitSearch(),
        decoration: InputDecoration(
          hintText: widget.searchHint,
          // Allow suffix to size to its children (avoids Row overflow).
          suffixIconConstraints: BoxConstraints(
            minHeight: 45.r,
            minWidth: 0,
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _SearchSuffixIcon(
                  icon: Icons.search,
                  onPressed: _submitSearch,
                ),
                if (hasActiveSearch)
                  _SearchSuffixIcon(
                    icon: Icons.close,
                    onPressed: _clearSearch,
                  ),
              ],
            ),
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

class _SearchSuffixIcon extends StatelessWidget {
  const _SearchSuffixIcon({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36.w,
      height: 36.r,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        constraints: BoxConstraints.tightFor(width: 36.w, height: 36.r),
        icon: Icon(icon, size: 20.r, color: AppColors.clr9AA4B2),
      ),
    );
  }
}
