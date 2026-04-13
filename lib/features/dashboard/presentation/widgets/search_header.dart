import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Solid teal header with rounded bottom + search row overlapping into the body.
class SearchHeader extends StatelessWidget {
  const SearchHeader({
    super.key,
    this.userName = 'Hafiz Bilal',
    this.onSearchSubmitted,
    this.onVoiceTap,
    this.onSearchButtonTap,
  });

  final String userName;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onSearchButtonTap;

  /// Design teal (header panel).
  static const Color _headerTeal = Color(0xFF52A898);

  /// Placeholder / icons — muted blue-grey & dark blue.
  static const Color _hintText = Color(0xFF1D4E89);
  static const Color _iconBlue = Color(0xFF024886);
  static const Color _fieldBg = Color(0xFFF3F4F6);
  static const String _micAsset = 'assets/svg/ic_search_mic.svg';

  static const double _cornerRadius = 28;
  static const double _searchHeight = 54.0;
  static const double _overlap = 24;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: _headerTeal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_cornerRadius),
                  bottomRight: Radius.circular(_cornerRadius),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(32, 18, 20, 42),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello, $userName',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 42 / 1.4,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: -_overlap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: _searchHeight,
                      decoration: BoxDecoration(
                        color: _fieldBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        onSubmitted: onSearchSubmitted,
                        textInputAction: TextInputAction.search,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF111827),
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Search Medicine, Doctor, Test....',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: _hintText,
                            fontWeight: FontWeight.w500,
                            fontSize: 34 / 2.4,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          suffixIcon: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onVoiceTap,
                              borderRadius: BorderRadius.circular(22),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 17,
                                  height: 23,
                                  child: SvgPicture.asset(_micAsset),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: _searchHeight,
                    height: _searchHeight,
                    decoration: BoxDecoration(
                      color: _fieldBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: onSearchButtonTap,
                        borderRadius: BorderRadius.circular(12),
                        child: const Center(
                          child: Icon(
                            Icons.search_rounded,
                            color: _iconBlue,
                            size: 34 / 1.35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Space for the part of the search row that sits below the teal block
        SizedBox(height: _overlap + 8),
      ],
    );
  }
}
