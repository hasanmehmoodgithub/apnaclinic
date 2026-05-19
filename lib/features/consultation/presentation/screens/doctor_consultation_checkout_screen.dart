import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../account/data/account_local_store.dart';
import '../../../account/domain/models/account_method.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../bookings/presentation/widgets/surgery_booking_details_header_widget.dart';
import '../cubit/doctor_consultation_checkout_cubit.dart';
import '../cubit/doctor_consultation_checkout_state.dart';
import '../doctor_consultation_checkout_args.dart';
import '../widgets/doctor_consultation_checkout_billing_section_widget.dart';
import '../widgets/doctor_consultation_jazzcash_accounts_sheet_widget.dart';
import '../widgets/doctor_consultation_checkout_payment_method_tile_widget.dart';
import '../widgets/doctor_consultation_checkout_shimmer_widget.dart';

class DoctorConsultationCheckoutScreen extends StatefulWidget {
  const DoctorConsultationCheckoutScreen({
    super.key,
    required this.args,
  });

  final DoctorConsultationCheckoutArgs args;

  @override
  State<DoctorConsultationCheckoutScreen> createState() =>
      _DoctorConsultationCheckoutScreenState();
}

class _DoctorConsultationCheckoutScreenState
    extends State<DoctorConsultationCheckoutScreen> {
  List<AccountMethod> _savedAccounts = const [];
  int _selectedAccountIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedAccounts();
    context.read<DoctorConsultationCheckoutCubit>().load();
  }

  Future<void> _loadSavedAccounts() async {
    final accounts = AccountLocalStore(sl<AppPref>()).getAccounts();
    if (!mounted) return;
    setState(() {
      _savedAccounts = accounts;
      _selectedAccountIndex = accounts.indexWhere((item) => item.isDefault);
      if (_selectedAccountIndex < 0) {
        _selectedAccountIndex = 0;
      }
    });
  }

  void _onPaymentMethodTap(String id) {
    context.read<DoctorConsultationCheckoutCubit>().selectPaymentMethod(id);
  }

  Future<void> _onContinuePressed(String? selectedPaymentMethodId) async {
    if (selectedPaymentMethodId == null) return;
    if (selectedPaymentMethodId == 'jazz_cash') {
      await _openJazzCashBottomSheet();
      return;
    }
  }

  Future<void> _openJazzCashBottomSheet() async {
    final selectedIndex = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DoctorConsultationJazzCashAccountsSheetWidget(
          accounts: _savedAccounts,
          initialSelectedIndex: _selectedAccountIndex,
        );
      },
    );
    if (selectedIndex == null || !mounted) return;
    if (selectedIndex == -1) {
      await context.pushNamed(AppRoutes.accountDetails);
      await _loadSavedAccounts();
      if (!mounted) return;
      await _openJazzCashBottomSheet();
      return;
    }
    setState(() => _selectedAccountIndex = selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFAEE3E3), Color(0xFFF5F7F8)],
            stops: [0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SurgeryBookingDetailsHeaderWidget(),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: widget.args.doctorImageUrl,
                    width: 188.w,
                    height: 160.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  ),
                  child: BlocBuilder<
                      DoctorConsultationCheckoutCubit,
                      DoctorConsultationCheckoutState>(
                    builder: (context, state) {
                      if (state.isLoading || state.data == null) {
                        return const DoctorConsultationCheckoutShimmerWidget();
                      }
                      final data = state.data!;
                      return Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DoctorConsultationCheckoutBillingSectionWidget(data: data),
                            SizedBox(height: 18.h),
                            Text(
                              l10n.consultationPaymentMethodTitle,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: const Color(0xFF061E40),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(height: 10.h),
                            Expanded(
                              child: ListView.separated(
                                itemCount: data.paymentOptions.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 12.h),
                                itemBuilder: (context, index) {
                                  final option = data.paymentOptions[index];
                                  final isSelected =
                                      state.selectedPaymentMethodId == option.id;
                                  return DoctorConsultationCheckoutPaymentMethodTileWidget(
                                    option: option,
                                    isSelected: isSelected,
                                    onTap: () => _onPaymentMethodTap(option.id),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 56.h,
                              child: FilledButton(
                                onPressed: state.selectedPaymentMethodId == null
                                    ? null
                                    : () => _onContinuePressed(
                                          state.selectedPaymentMethodId,
                                        ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF1FAFA3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                child: Text(l10n.commonContinue),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
