import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/apna_clinic_ai_card_entity.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

class ApnaClinicAiDoctorCard extends StatelessWidget {
  const ApnaClinicAiDoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  final ApnaClinicAiDoctorCardEntity doctor;
  final VoidCallback onTap;

  /// Fixed card size used by the horizontal rail.
  static double railHeight(BuildContext context) => 224.h;

  /// Shorter rail for payment methods (image, label, pay button).
  static double paymentRailHeight(BuildContext context) => 168.h;

  /// Experience and price, each at most once, even if the source line repeats them.
  static String _onceEach(String? years, String? fee) {
    final combined = [years, fee]
        .map((part) => (part ?? '').trim())
        .where((part) => part.isNotEmpty)
        .join(' • ');
    if (combined.isEmpty) return '';
    final experience = RegExp(
      r'\d+\s*yrs?',
      caseSensitive: false,
    ).firstMatch(combined)?.group(0)?.trim();
    final price = RegExp(
      r'PKR\s*[\d,.]+',
      caseSensitive: false,
    ).firstMatch(combined)?.group(0)?.trim();
    return [
      if (experience != null && experience.isNotEmpty) experience,
      if (price != null && price.isNotEmpty) price,
    ].join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMedicine = doctor.isMedicine;
    final badge = (doctor.badge ?? doctor.specialty ?? '').trim();
    final description = (doctor.description ?? '').trim();
    final rating = (doctor.rating ?? '').trim();
    final footer = _onceEach(doctor.years, doctor.fee);
    final cta = (doctor.cta ?? '').trim().isNotEmpty
        ? doctor.cta!.trim()
        : (isMedicine ? l10n.apnaClinicAiAddToCart : l10n.apnaClinicAiViewSlots);
    final compact = doctor.isPayment;

    return Material(
      color: ApnaClinicAiUiConfig.panel,
      borderRadius: BorderRadius.circular(compact ? 14.r : 16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(compact ? 14.r : 16.r),
        child: Container(
          width: compact ? 142.w : 164.w,
          height: compact ? paymentRailHeight(context) : railHeight(context),
          padding: EdgeInsets.all(compact ? 7.r : 8.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 14.r : 16.r),
            border: Border.all(color: ApnaClinicAiUiConfig.borderStrong),
            boxShadow: ApnaClinicAiUiConfig.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumb(
                name: doctor.name,
                imageUrl: doctor.imageUrl,
                height: compact ? 58.h : 72.h,
              ),
              SizedBox(height: compact ? 6.h : 8.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (badge.isNotEmpty)
                      Text(
                        badge.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                          color: ApnaClinicAiUiConfig.ctaDeep,
                        ),
                      ),
                    if (badge.isNotEmpty) SizedBox(height: 2.h),
                    Text(
                      doctor.name,
                      maxLines: compact ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ApnaClinicAiUiConfig.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                        height: 1.15,
                        letterSpacing: -0.1,
                      ),
                    ),
                    if (description.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          description,
                          maxLines: compact ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ApnaClinicAiUiConfig.secondaryText,
                            fontSize: 11.sp,
                            height: 1.2,
                          ),
                        ),
                      )
                    else if (rating.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          rating,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ApnaClinicAiUiConfig.muted,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (footer.isNotEmpty)
                      Text(
                        footer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ApnaClinicAiUiConfig.primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 6.h),
              SizedBox(
                width: double.infinity,
                height: compact ? 28.h : 30.h,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ApnaClinicAiUiConfig.cta,
                    foregroundColor: ApnaClinicAiUiConfig.panel,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    cta,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
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

class _Thumb extends StatelessWidget {
  const _Thumb({required this.name, this.imageUrl, this.height = 72});

  final String name;
  final String? imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: ApnaClinicAiUiConfig.mint,
        border: Border.all(color: ApnaClinicAiUiConfig.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: _imageOrFallback(),
    );
  }

  Widget _imageOrFallback() {
    final url = imageUrl?.trim() ?? '';
    if (url.isNotEmpty && _isNetwork(url)) {
      return SizedBox.expand(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (_, _) => _fallback(),
          errorWidget: (_, _, _) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return ColoredBox(
      color: ApnaClinicAiUiConfig.ctaSoft,
      child: Center(
        child: Text(
          _initials(name),
          style: TextStyle(
            color: ApnaClinicAiUiConfig.ctaDeep,
            fontWeight: FontWeight.w700,
            fontSize: 22.sp,
          ),
        ),
      ),
    );
  }

  bool _isNetwork(String value) {
    final lower = value.toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  String _initials(String value) {
    final parts = value
        .replaceFirst(
          RegExp(
            r'^(Assist\.?\s*Prof\.?\s*|Prof\.?\s*|Dr\.?\s*)+',
            caseSensitive: false,
          ),
          '',
        )
        .trim()
        .split(RegExp(r'\s+'));
    final first = parts.isNotEmpty && parts.first.isNotEmpty ? parts.first[0] : 'A';
    final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return '$first$second'.toUpperCase();
  }
}
