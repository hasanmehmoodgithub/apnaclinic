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
  static double railHeight(BuildContext context) => 268.h;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMedicine = doctor.isMedicine;
    final badge = (doctor.badge ?? doctor.specialty ?? '').trim();
    final description = (doctor.description ?? '').trim();
    final rating = (doctor.rating ?? '').trim();
    final years = (doctor.years ?? '').trim();
    final fee = (doctor.fee ?? '').trim();
    final footer = [
      if (years.isNotEmpty) years,
      if (fee.isNotEmpty) fee,
    ].join(' • ');
    final cta = (doctor.cta ?? '').trim().isNotEmpty
        ? doctor.cta!.trim()
        : (isMedicine ? l10n.apnaClinicAiAddToCart : l10n.apnaClinicAiViewSlots);

    return Material(
      color: ApnaClinicAiUiConfig.panel,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: 200.w,
          height: railHeight(context),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ApnaClinicAiUiConfig.borderStrong),
            boxShadow: ApnaClinicAiUiConfig.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumb(
                name: doctor.name,
                imageUrl: doctor.imageUrl,
                medicine: isMedicine,
              ),
              SizedBox(height: 8.h),
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
                    if (badge.isNotEmpty) SizedBox(height: 4.h),
                    Text(
                      doctor.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ApnaClinicAiUiConfig.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                        height: 1.2,
                        letterSpacing: -0.1,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ApnaClinicAiUiConfig.secondaryText,
                          fontSize: 11.sp,
                          height: 1.25,
                        ),
                      ),
                    ] else if (rating.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        rating,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ApnaClinicAiUiConfig.muted,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
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
              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                height: 34.h,
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
  const _Thumb({
    required this.name,
    required this.medicine,
    this.imageUrl,
  });

  final String name;
  final String? imageUrl;
  final bool medicine;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: medicine ? 80.h : 96.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
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
      return CachedNetworkImage(
        imageUrl: url,
        fit: medicine ? BoxFit.contain : BoxFit.cover,
        placeholder: (_, _) => _fallback(),
        errorWidget: (_, _, _) => _fallback(),
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
