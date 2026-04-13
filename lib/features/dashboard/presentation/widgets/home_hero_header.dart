import 'package:flutter/material.dart';

/// Solid teal header with rounded bottom + search row overlapping into the body.
class HomeHeroHeader extends StatelessWidget {
  const HomeHeroHeader({
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
  static const Color _hintText = Color(0xFF5A6B7A);
  static const Color _iconBlue = Color(0xFF024886);

  static const double _cornerRadius = 28;
  static const double _searchHeight = 52.0;
  static const double _overlap = 26;

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
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello, $userName',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: -_overlap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: _searchHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
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
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onVoiceTap,
                              borderRadius: BorderRadius.circular(22),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.mic_none_rounded,
                                  color: _iconBlue,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: _searchHeight,
                    height: _searchHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: onSearchButtonTap,
                        borderRadius: BorderRadius.circular(16),
                        child: const Center(
                          child: Icon(
                            Icons.search_rounded,
                            color: _iconBlue,
                            size: 26,
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
