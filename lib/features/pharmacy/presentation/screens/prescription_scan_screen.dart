import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/prescription_scan_error_codes.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../pharmacy_navigation.dart';
import '../pharmacy_prescription_scan_analytics.dart';
import '../widgets/pharmacy_scan_banner_card.dart';
import '../widgets/pharmacy_screen_header_widget.dart';
import '../widgets/prescription_scan_picker.dart';
import '../widgets/prescription_scan_result.dart';
import '../widgets/prescription_scan_source_sheet.dart';

class PrescriptionScanScreen extends StatefulWidget {
  const PrescriptionScanScreen({super.key});

  @override
  State<PrescriptionScanScreen> createState() => _PrescriptionScanScreenState();
}

class _PrescriptionScanScreenState extends State<PrescriptionScanScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  var _closedLogged = false;

  Future<void> _pickImage() async {
    final source = await showPrescriptionScanSourceSheet(context);
    if (source == null || !mounted) return;
    PharmacyPrescriptionScanAnalytics.logSourceSelected(source);
    final l10n = AppLocalizations.of(context)!;
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1600,
      );
      if (picked == null || !mounted) return;
      PharmacyPrescriptionScanAnalytics.logPicked(source);
      context.read<PharmacyCubit>().setPrescriptionImage(picked.path);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileImagePickerFailedMessage)),
      );
    }
  }

  void _logClosed() {
    if (_closedLogged) return;
    _closedLogged = true;
    PharmacyPrescriptionScanAnalytics.logClosed();
  }

  String? _errorText(AppLocalizations l10n, String? code) {
    if (code == null || code.isEmpty) return null;
    if (code == PrescriptionScanErrorCodes.notConfigured) {
      return l10n.pharmacyScanNotConfigured;
    }
    if (code == PrescriptionScanErrorCodes.extractFailed) {
      return l10n.pharmacyScanFailed;
    }
    return code;
  }

  @override
  void initState() {
    super.initState();
    context.read<PharmacyCubit>().clearPrescriptionScan();
    PharmacyPrescriptionScanAnalytics.logOpened();
  }

  @override
  void dispose() {
    _logClosed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _logClosed();
      },
      child: Scaffold(
      backgroundColor: AppColors.clrF4F6F8,
      body: SafeArea(
        child: Column(
          children: [
            BlocSelector<PharmacyCubit, PharmacyState, int>(
              selector: (state) => state.cartCount,
              builder: (context, cartCount) {
                return PharmacyScreenHeaderWidget(
                  title: l10n.pharmacyScanPrescription,
                  cartCount: cartCount,
                  cartContainerSize: 22.r,
                  cartIconSize: 11.r,
                  onBackTap: () {
                    _logClosed();
                    pharmacyPopOrGoHome(context);
                  },
                  onCartTap: () => pharmacyOpenCart(context),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<PharmacyCubit, PharmacyState>(
                buildWhen: (previous, next) =>
                    previous.prescriptionScan != next.prescriptionScan,
                builder: (context, state) {
                  final scan = state.prescriptionScan;
                  final errorText = _errorText(l10n, scan.errorCode);
                  final showBanner = scan.result == null;
                  return ListView(
                    padding: EdgeInsets.fromLTRB(18.w, 2.h, 18.w, 28.h),
                    children: [
                      if (showBanner) ...[
                        const PharmacyScanBannerCard(),
                        SizedBox(height: 18.h),
                      ],
                      PrescriptionScanPicker(
                        imagePath: scan.imagePath,
                        extracting: scan.extracting,
                        onPick: _pickImage,
                        onExtract: () =>
                            context.read<PharmacyCubit>().extractPrescription(),
                      ),
                      if (errorText != null) ...[
                        SizedBox(height: 12.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.clrE01F26.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.clrE01F26.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            errorText,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.clrE01F26,
                                  height: 1.35,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                      if (scan.result != null) ...[
                        SizedBox(height: 18.h),
                        PrescriptionScanResult(
                          result: scan.result!,
                          matches: scan.matches,
                          prescriptionPath: scan.imagePath,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
