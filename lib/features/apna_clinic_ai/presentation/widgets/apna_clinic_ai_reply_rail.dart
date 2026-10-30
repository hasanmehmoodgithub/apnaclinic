import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../payment/presentation/payment_navigation.dart';
import '../../../pharmacy/presentation/pharmacy_navigation.dart';
import '../../domain/entities/apna_clinic_ai_card_entity.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_state.dart';
import 'apna_clinic_ai_doctor_card.dart';
import 'apna_clinic_ai_slot_calendar.dart';

class ApnaClinicAiReplyRail extends StatelessWidget {
  const ApnaClinicAiReplyRail({
    super.key,
    required this.state,
    required this.onSend,
    this.onSignIn,
  });

  final ApnaClinicAiState state;
  final ValueChanged<String> onSend;
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasSlots =
        state.slotDays.isNotEmpty || state.slots.isNotEmpty;
    // Slot calendar replaces doctor cards for this turn (avoids duplicate UI).
    final paymentCards = state.doctors.where((d) => d.isPayment).toList();
    final doctors = hasSlots
        ? const <ApnaClinicAiDoctorCardEntity>[]
        : state.doctors
              .where((d) => !d.isMedicine && !d.isPayment)
              .toList();
    final medicines = state.doctors.where((d) => d.isMedicine).toList();

    if (!state.emergencyVisible &&
        doctors.isEmpty &&
        paymentCards.isEmpty &&
        medicines.isEmpty &&
        state.slots.isEmpty &&
        state.slotDays.isEmpty &&
        state.payments.isEmpty &&
        state.quickActions.isEmpty &&
        !state.signInRequired) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.emergencyVisible) const _EmergencyCard(),
          if (state.signInRequired) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                l10n.apnaClinicAiSignInRequired,
                style: TextStyle(
                  color: ApnaClinicAiUiConfig.secondaryText,
                  fontSize: 12.sp,
                ),
              ),
            ),
            if (onSignIn != null)
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: ApnaClinicAiUiConfig.cta,
                      foregroundColor: ApnaClinicAiUiConfig.panel,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: onSignIn,
                    child: Text(
                      l10n.apnaClinicAiSignInCta,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
          ],
          if (doctors.isNotEmpty)
            _CardRail(
              title: _sectionTitle('doctor', l10n.apnaClinicAiTapDoctor),
              cards: doctors,
              onSend: onSend,
            ),
          if (medicines.isNotEmpty)
            _CardRail(
              title: _sectionTitle('medicine', l10n.apnaClinicAiMedicines),
              cards: medicines,
              onSend: onSend,
            ),
          if (paymentCards.isNotEmpty)
            _PaymentList(
              title: _sectionTitle('payment', l10n.apnaClinicAiPayment),
              cards: paymentCards,
              onSend: onSend,
            ),
          if (state.slotDays.isNotEmpty)
            ApnaClinicAiSlotCalendar(
              days: state.slotDays,
              onSend: onSend,
              title: _sectionTitle('slots', l10n.apnaClinicAiSlots),
            )
          else if (state.slots.isNotEmpty)
            _FlatSlots(
              slots: state.slots,
              onSend: onSend,
              title: _sectionTitle('slots', l10n.apnaClinicAiSlots),
            ),
          if (paymentCards.isEmpty && state.payments.isNotEmpty)
            _Section(
              title: _sectionTitle('payment', l10n.apnaClinicAiPayment),
              children: [
                for (final payment in state.payments)
                  _ChoiceTile(
                    icon: payment.opensPaymentWebView
                        ? Icons.credit_card_rounded
                        : _paymentIcon(payment.label),
                    label: payment.label.trim().isNotEmpty
                        ? payment.label.trim()
                        : l10n.apnaClinicAiPayNow,
                    hint: payment.hint,
                    onTap: () => _onPaymentTap(context, payment),
                  ),
              ],
            ),
          if (state.quickActions.isNotEmpty) ...[
            if (_sectionTitle('chips', '').isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  _sectionTitle('chips', ''),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: ApnaClinicAiUiConfig.primaryText,
                  ),
                ),
              ),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final action in state.quickActions)
                  _Chip(label: action.label, onTap: () => onSend(action.send)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _sectionTitle(String key, String fallback) {
    final fromBlock = (state.sectionTitles[key] ?? '').trim();
    return fromBlock.isNotEmpty ? fromBlock : fallback;
  }

  void _onPaymentTap(BuildContext context, ApnaClinicAiPaymentEntity payment) {
    final url = payment.url?.trim() ?? '';
    if (payment.opensPaymentWebView) {
      openCardPaymentWebView(
        context,
        paymentUrl: url,
        title: payment.label.trim().isNotEmpty
            ? payment.label.trim()
            : AppLocalizations.of(context)!.apnaClinicAiPayNow,
        allowClose: true,
      );
      return;
    }
    if (payment.opensPharmacyCart) {
      pharmacyOpenCart(context);
      return;
    }
    onSend(payment.send);
  }

  IconData _paymentIcon(String label) {
    final upper = label.toUpperCase();
    if (upper.contains('JAZZ')) return Icons.phone_android_rounded;
    if (upper.contains('BNPL') || upper.contains('YEYLO')) {
      return Icons.calendar_month_outlined;
    }
    return Icons.credit_card_rounded;
  }
}

class _CardRail extends StatelessWidget {
  const _CardRail({
    required this.title,
    required this.cards,
    required this.onSend,
  });

  final String title;
  final List<ApnaClinicAiDoctorCardEntity> cards;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: ApnaClinicAiUiConfig.secondaryText,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: cards.isNotEmpty && cards.first.isPayment
                ? ApnaClinicAiDoctorCard.paymentRailHeight(context)
                : ApnaClinicAiDoctorCard.railHeight(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              separatorBuilder: (_, _) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final card = cards[index];
                return ApnaClinicAiDoctorCard(
                  doctor: card,
                  onTap: () => onSend(card.send),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FlatSlots extends StatelessWidget {
  const _FlatSlots({
    required this.slots,
    required this.onSend,
    required this.title,
  });

  final List<ApnaClinicAiSlotEntity> slots;
  final ValueChanged<String> onSend;
  final String title;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: title,
      children: [
        for (final slot in slots)
          _ChoiceTile(
            icon: Icons.schedule_rounded,
            label: slot.label,
            onTap: () => onSend(slot.send),
          ),
      ],
    );
  }
}

class _PaymentList extends StatelessWidget {
  const _PaymentList({
    required this.title,
    required this.cards,
    required this.onSend,
  });

  final String title;
  final List<ApnaClinicAiDoctorCardEntity> cards;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: title,
      children: [
        for (final card in cards)
          _PaymentRow(card: card, onTap: () => onSend(card.send)),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.card, required this.onTap});

  final ApnaClinicAiDoctorCardEntity card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final badge = (card.badge ?? '').trim();
    final detail = (card.description ?? '').trim();
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: ApnaClinicAiUiConfig.panel,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ApnaClinicAiUiConfig.border),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: SizedBox(
                    width: 52.r,
                    height: 52.r,
                    child: _PaymentThumb(name: card.name, imageUrl: card.imageUrl),
                  ),
                ),
                SizedBox(width: 10.w),
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
                            color: ApnaClinicAiUiConfig.ctaDeep,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      Text(
                        card.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ApnaClinicAiUiConfig.primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                      if (detail.isNotEmpty)
                        Text(
                          detail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ApnaClinicAiUiConfig.secondaryText,
                            fontSize: 12.sp,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: ApnaClinicAiUiConfig.secondaryText,
                  size: 20.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentThumb extends StatelessWidget {
  const _PaymentThumb({required this.name, this.imageUrl});

  final String name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';
    final network =
        url.startsWith('http://') || url.startsWith('https://');
    if (!network) {
      return const ColoredBox(color: ApnaClinicAiUiConfig.ctaSoft);
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: 52.r,
      height: 52.r,
      placeholder: (_, _) =>
          const ColoredBox(color: ApnaClinicAiUiConfig.mint),
      errorWidget: (_, _, _) => ColoredBox(
        color: ApnaClinicAiUiConfig.ctaSoft,
        child: Center(
          child: Text(
            name.isEmpty ? 'P' : name[0].toUpperCase(),
            style: TextStyle(
              color: ApnaClinicAiUiConfig.ctaDeep,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: ApnaClinicAiUiConfig.secondaryText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          ...children,
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.hint,
  });

  final IconData icon;
  final String label;
  final String? hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: ApnaClinicAiUiConfig.panel,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ApnaClinicAiUiConfig.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: const BoxDecoration(
                    color: ApnaClinicAiUiConfig.ctaSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: ApnaClinicAiUiConfig.cta, size: 20.r),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: ApnaClinicAiUiConfig.primaryText,
                        ),
                      ),
                      if (hint != null && hint!.isNotEmpty)
                        Text(
                          hint!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ApnaClinicAiUiConfig.secondaryText,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: ApnaClinicAiUiConfig.secondaryText,
                  size: 20.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          color: ApnaClinicAiUiConfig.cta,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: ApnaClinicAiUiConfig.ctaSoft,
      side: const BorderSide(color: ApnaClinicAiUiConfig.border),
      onPressed: onTap,
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = [
      l10n.apnaClinicAiEmergencyStep1,
      l10n.apnaClinicAiEmergencyStep2,
      l10n.apnaClinicAiEmergencyStep3,
    ];
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ApnaClinicAiUiConfig.emergencyBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ApnaClinicAiUiConfig.emergencyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.apnaClinicAiEmergencyTitle,
            style: TextStyle(
              color: ApnaClinicAiUiConfig.emergencyText,
              fontWeight: FontWeight.w800,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            l10n.apnaClinicAiEmergencyBody,
            style: TextStyle(
              color: ApnaClinicAiUiConfig.primaryText,
              fontSize: 13.sp,
              height: 1.35,
            ),
          ),
          SizedBox(height: 8.h),
          for (final step in steps)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                '• $step',
                style: TextStyle(
                  color: ApnaClinicAiUiConfig.primaryText,
                  fontSize: 13.sp,
                ),
              ),
            ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ApnaClinicAiUiConfig.emergencyText,
                foregroundColor: ApnaClinicAiUiConfig.panel,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () => launchUrl(Uri.parse('tel:1122')),
              child: Text(
                l10n.apnaClinicAiEmergencyCta,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
