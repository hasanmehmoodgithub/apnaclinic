import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

/// Search input used by the pharmacy main panel.
class PharmacyMainSearchFieldWidget extends StatelessWidget {
  const PharmacyMainSearchFieldWidget({
    super.key,
    required this.searchQuery,
    required this.searchHint,
    required this.onSearchChanged,
  });

  final String searchQuery;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45.r,
      child: TextFormField(
        onChanged: onSearchChanged,
        initialValue: searchQuery,
        decoration: InputDecoration(
          hintText: searchHint,
          suffixIcon: const Icon(Icons.search, color: Color(0xFF9AA4B2)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 14.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: Color(0xFFE3E8EE)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: Color(0xFFE3E8EE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: Color(0xFF9EC7E8)),
          ),
        ),
      ),
    );
  }
}
