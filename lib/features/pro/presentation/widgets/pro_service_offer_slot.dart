import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../../consultation/presentation/consultation_pro_navigation.dart';
import '../../../lab_test/presentation/lab_test_pro_navigation.dart';
import '../../domain/entities/pro_benefit_entity.dart';
import '../../domain/entities/pro_catalog_entity.dart';
import '../../domain/use_cases/get_pro_catalog_use_case.dart';
import '../show_pro_bottom_sheet.dart';
import 'pro_show_info_widget.dart';

enum ProServiceOfferKind { consultation, lab, pharmacy }

/// Pro upsell on a service screen. Active members see [Assets.proProBadge].
class ProServiceOfferSlot extends StatefulWidget {
  const ProServiceOfferSlot({
    super.key,
    required this.service,
    this.upsellOnly = false,
    this.onProChanged,
  });

  final ProServiceOfferKind service;

  /// When true, active members render nothing. Checkout screens draw their
  /// own discount or delivery row.
  final bool upsellOnly;

  /// Fired after each membership load, including after subscribe or cancel.
  final ValueChanged<bool>? onProChanged;

  @override
  State<ProServiceOfferSlot> createState() => ProServiceOfferSlotState();
}

class ProServiceOfferSlotState extends State<ProServiceOfferSlot> {
  ProCatalogEntity? _catalog;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await sl<GetProCatalogUseCase>()();
    if (!mounted) return;
    final catalog = result.fold<ProCatalogEntity?>((_) => null, (value) => value);
    final isPro = catalog?.membership.isActivePro == true;
    setState(() {
      _catalog = catalog;
      _loaded = true;
    });
    widget.onProChanged?.call(isPro);
  }

  /// Opens the Pro sheet, then reloads membership for subscribe and cancel.
  Future<void> openSheet() => _openPro();

  Future<void> _openPro() async {
    final result = await showApnaClinicProSheet(context);
    if (!mounted) return;
    await _load();
    if (!mounted) return;

    final subscribed = result != null &&
        !result.subscriptionCancelled &&
        result.planId.isNotEmpty;
    if (!subscribed) return;
    switch (widget.service) {
      case ProServiceOfferKind.consultation:
        popToConsultationDoctors(context);
      case ProServiceOfferKind.lab:
        popToLabTestSelectTest(context);
      case ProServiceOfferKind.pharmacy:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final benefit = _benefitFor(widget.service, _catalog);
    final isPro = _catalog?.membership.isActivePro == true;
    if (isPro && widget.upsellOnly) return const SizedBox.shrink();
    if (isPro) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: InkWell(
          onTap: _openPro,
          child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.consultationDiscountLabel,
                    style: TextStyle(
                      color: AppColors.clr98A4B5,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _percentLabel(_discount(l10n, benefit)),
                    style: TextStyle(
                      color: AppColors.clr5D758F,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              Assets.proProBadge,
              height: 18.h,
              fit: BoxFit.contain,
            ),
          ],
        ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: ProShowInfoWidget(
        title: _title(l10n, benefit),
        subtitle: l10n.proShowInfoSubtitle,
        discount: _discount(l10n, benefit),
        onSubscribeTap: () => _openPro(),
      ),
    );
  }

  String _title(AppLocalizations l10n, ProBenefitEntity? benefit) {
    final fromApi = benefit?.title.trim() ?? '';
    if (fromApi.isNotEmpty) return fromApi;
    return switch (widget.service) {
      ProServiceOfferKind.consultation => l10n.proShowInfoConsultationTitle,
      ProServiceOfferKind.lab => l10n.proShowInfoLabTitle,
      ProServiceOfferKind.pharmacy => l10n.proShowInfoPharmacyTitle,
    };
  }

  String _percentLabel(String raw) {
    final match = RegExp(r'\d+\s*%').firstMatch(raw);
    if (match == null) return raw.trim();
    return match.group(0)!.replaceAll(' ', '');
  }

  String _discount(AppLocalizations l10n, ProBenefitEntity? benefit) {
    final fromApi = benefit?.proValue.trim() ?? '';
    if (fromApi.isNotEmpty) return fromApi;
    return switch (widget.service) {
      ProServiceOfferKind.consultation => l10n.proShowInfoConsultationDiscount,
      ProServiceOfferKind.lab => l10n.proShowInfoLabDiscount,
      ProServiceOfferKind.pharmacy => l10n.proShowInfoPharmacyDiscount,
    };
  }

  ProBenefitEntity? _benefitFor(
    ProServiceOfferKind service,
    ProCatalogEntity? catalog,
  ) {
    final benefits = catalog?.benefits ?? const <ProBenefitEntity>[];
    final keys = switch (service) {
      ProServiceOfferKind.consultation => const ['consultation'],
      ProServiceOfferKind.lab => const ['lab', 'lab_test'],
      ProServiceOfferKind.pharmacy => const [
          'pharmacy',
          'pharmacy_delivery',
        ],
    };
    for (final benefit in benefits) {
      if (keys.contains(benefit.key.trim().toLowerCase())) return benefit;
    }
    return null;
  }
}
