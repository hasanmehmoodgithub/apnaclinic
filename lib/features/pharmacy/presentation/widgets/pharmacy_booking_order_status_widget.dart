import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/pharmacy_booking_detail_entity.dart';

class PharmacyBookingOrderStatusWidget extends StatelessWidget {
  const PharmacyBookingOrderStatusWidget({
    super.key,
    required this.isCancelled,
    required this.steps,
    this.cancelledLabel,
  });

  final bool isCancelled;
  final List<PharmacyBookingTimelineStepEntity> steps;

  /// Display text from API `statusV2` when the order is cancelled/failed.
  final String? cancelledLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = _buildItems(l10n);
    final statusV2Label = cancelledLabel?.trim() ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.pharmacyBookingOrderStatusTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.clr060,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 10.h),
        if (isCancelled)
          _CancelledRow(
            label: statusV2Label.isNotEmpty
                ? statusV2Label
                : l10n.pharmacyBookingStatusCancelled,
          )
        else
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Padding(
              padding:
                  EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 8.h),
              child: _TimelineRow(
                item: item,
                showConnector: index != items.length - 1,
              ),
            );
          }),
      ],
    );
  }

  List<_TimelineItem> _buildItems(AppLocalizations l10n) {
    if (steps.isEmpty) {
      return [
        _TimelineItem(
          label: l10n.pharmacyBookingStatusConfirmed,
          state: _ItemState.active,
        ),
        _TimelineItem(
          label: l10n.pharmacyBookingStatusReadyForDispatch,
          state: _ItemState.upcoming,
        ),
        _TimelineItem(
          label: l10n.pharmacyBookingStatusDispatched,
          state: _ItemState.upcoming,
        ),
        _TimelineItem(
          label: l10n.pharmacyBookingStatusCompleted,
          state: _ItemState.upcoming,
        ),
      ];
    }

    final firstIncomplete = steps.indexWhere((step) => !step.completed);
    return List.generate(steps.length, (index) {
      final step = steps[index];
      final _ItemState state;
      if (step.completed) {
        state = _ItemState.done;
      } else if (firstIncomplete == -1) {
        state = _ItemState.done;
      } else if (index == firstIncomplete) {
        state = _ItemState.active;
      } else {
        state = _ItemState.upcoming;
      }
      return _TimelineItem(label: step.label, state: state);
    });
  }
}

class _CancelledRow extends StatelessWidget {
  const _CancelledRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20.r,
          height: 20.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFFF4F4F), width: 0.5),
          ),
          child: Icon(
            Icons.close_rounded,
            color: const Color(0xFFFF4F4F),
            size: 14.r,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4F4F),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.clrWhite,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item, required this.showConnector});

  final _TimelineItem item;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final isDone = item.state == _ItemState.done;
    final isActive = item.state == _ItemState.active;
    final cardColor = isDone
        ? AppColors.clr0FAA9A
        : (isActive ? const Color(0xFFE7F7F5) : const Color(0xFFDDF0ED));
    final borderColor = isDone
        ? AppColors.clrWhite
        : (isActive ? AppColors.clr0FAA9A : AppColors.clrWhite);
    final textColor = isDone
        ? AppColors.clrWhite
        : (isActive ? AppColors.clr4A555F : const Color(0xFFC5C5C5));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28.w,
          child: Column(
            children: [
              _TimelineDot(state: item.state),
              if (showConnector)
                Container(
                  width: 1.w,
                  height: 36.h,
                  color: const Color(0xFFDDE1E5),
                ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: borderColor),
            ),
            child: Text(
              item.label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.state});

  final _ItemState state;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _ItemState.done:
        return Container(
          width: 20.r,
          height: 20.r,
          decoration: BoxDecoration(
            color: AppColors.clr0FAA9A,
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.check_rounded, color: AppColors.clrWhite, size: 12.r),
        );
      case _ItemState.active:
        return Container(
          width: 20.r,
          height: 20.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.clr0FAA9A, width: 0.5),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 10.r,
            height: 10.r,
            decoration: BoxDecoration(
              color: AppColors.clr0FAA9A,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
      case _ItemState.upcoming:
        return Container(
          width: 20.r,
          height: 20.r,
          decoration: BoxDecoration(
            color: const Color(0x1A0FAA9A),
            borderRadius: BorderRadius.circular(20.r),
          ),
        );
    }
  }
}

enum _ItemState { done, active, upcoming }

class _TimelineItem {
  const _TimelineItem({required this.label, required this.state});

  final String label;
  final _ItemState state;
}
