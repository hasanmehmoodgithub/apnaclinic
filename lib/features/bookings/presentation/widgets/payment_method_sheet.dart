import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../../consultation/data/utils/consultation_booking_utils.dart';
import '../../../consultation/domain/entities/payment_provider_entity.dart';
import '../../../consultation/domain/use_cases/get_payment_providers_use_case.dart';
import 'payment_option.dart';

class PaymentMethodSheet extends StatefulWidget {
  const PaymentMethodSheet({
    super.key,
    required this.module,
  });

  /// One of [PaymentProviderModule] values: consultation, lab, surgery, pharmacy.
  final String module;

  @override
  State<PaymentMethodSheet> createState() => PaymentMethodSheetState();
}

class PaymentMethodSheetState extends State<PaymentMethodSheet> {
  final GetPaymentProvidersUseCase _getPaymentProvidersUseCase =
      sl<GetPaymentProvidersUseCase>();

  bool _isLoading = true;
  String? _errorMessage;
  List<PaymentProviderEntity> _providers = const [];
  String? _selectedCode;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _getPaymentProvidersUseCase(
      GetPaymentProvidersParams(module: widget.module),
    );
    if (!mounted) return;

    result.fold(
      (error) => setState(() {
        _isLoading = false;
        _errorMessage = error;
        _providers = const [];
        _selectedCode = null;
      }),
      (providers) => setState(() {
        _isLoading = false;
        _providers = providers;
        _selectedCode = providers.isNotEmpty ? providers.first.code : null;
        _errorMessage = providers.isEmpty ? AppStrings.genericErrorMessage : null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 38.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD3D9),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.consultationPaymentMethodTitle,
                  style: textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            if (_isLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28.h),
                child: SizedBox(
                  width: 28.r,
                  height: 28.r,
                  child: const CircularProgressIndicator(strokeWidth: 2.4),
                ),
              )
            else if (_errorMessage != null)
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
                child: Column(
                  children: [
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF667B99),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: _loadProviders,
                      child: Text(l10n.commonRetry),
                    ),
                  ],
                ),
              )
            else
              ..._buildProviderOptions(),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: _selectedCode == null
                      ? null
                      : () => context.pop(_selectedCode),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1AB6A1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    l10n.commonProceed,
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProviderOptions() {
    final widgets = <Widget>[];
    for (var index = 0; index < _providers.length; index++) {
      final provider = _providers[index];
      if (index > 0) {
        widgets.add(
          Container(
            height: 0.6,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            color: const Color(0xFFE2E8EE),
          ),
        );
      }
      widgets.add(
        PaymentOption(
          value: provider.code,
          groupValue: _selectedCode ?? '',
          onChanged: (value) => setState(() => _selectedCode = value),
          label: provider.name,
          iconBuilder: () => _paymentIcon(
            child: _providerIcon(provider),
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _providerIcon(PaymentProviderEntity provider) {
    final iconUrl = provider.iconUrl.trim();
    if (iconUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: iconUrl,
        width: 34.w,
        height: 18.h,
        fit: BoxFit.contain,
        placeholder: (_, _) => _fallbackProviderIcon(provider),
        errorWidget: (_, _, _) => _fallbackProviderIcon(provider),
      );
    }
    return _fallbackProviderIcon(provider);
  }

  Widget _fallbackProviderIcon(PaymentProviderEntity provider) {
    if (ConsultationBookingUtils.isJazzCashPayment(
      provider.code,
      name: provider.name,
    )) {
      return SvgPicture.asset(
        Assets.iconsJazzCash,
        width: 34.w,
        height: 18.h,
        fit: BoxFit.contain,
      );
    }

    final normalizedCode =
        provider.code.trim().toUpperCase().replaceAll(RegExp(r'[\s_-]'), '');
    if (normalizedCode == 'CARD' || normalizedCode.contains('CARD')) {
      return SvgPicture.asset(
        Assets.iconsDebitCard,
        width: 34.w,
        height: 18.h,
        fit: BoxFit.contain,
      );
    }

    return Icon(
      Icons.payment_rounded,
      size: 22.r,
      color: const Color(0xFF1F8AC7),
    );
  }

  Widget _paymentIcon({required Widget child}) {
    return Container(
      width: 42.w,
      height: 42.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE2E8EE),
          width: 0.6,
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
