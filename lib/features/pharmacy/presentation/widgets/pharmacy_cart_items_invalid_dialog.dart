import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../domain/entities/pharmacy_cart_invalid_item_entity.dart';
import 'pharmacy_network_image.dart';

Future<void> showPharmacyCartItemsInvalidDialog(
  BuildContext context, {
  required String message,
  required List<PharmacyCartInvalidItemEntity> failedItems,
  required Future<void> Function(PharmacyCartInvalidItemEntity item) onRemove,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return _PharmacyCartItemsInvalidDialog(
        message: message,
        failedItems: failedItems,
        onRemove: onRemove,
      );
    },
  );
}

class _PharmacyCartItemsInvalidDialog extends StatefulWidget {
  const _PharmacyCartItemsInvalidDialog({
    required this.message,
    required this.failedItems,
    required this.onRemove,
  });

  final String message;
  final List<PharmacyCartInvalidItemEntity> failedItems;
  final Future<void> Function(PharmacyCartInvalidItemEntity item) onRemove;

  @override
  State<_PharmacyCartItemsInvalidDialog> createState() =>
      _PharmacyCartItemsInvalidDialogState();
}

class _PharmacyCartItemsInvalidDialogState
    extends State<_PharmacyCartItemsInvalidDialog> {
  late List<PharmacyCartInvalidItemEntity> _items;
  final Set<int> _removing = {};

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.failedItems);
  }

  Future<void> _remove(PharmacyCartInvalidItemEntity item) async {
    if (_removing.contains(item.productId)) return;
    setState(() => _removing.add(item.productId));
    await widget.onRemove(item);
    if (!mounted) return;
    setState(() {
      _removing.remove(item.productId);
      _items.removeWhere((e) => e.productId == item.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 14.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.pharmacyCartItemsInvalidTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.clr060,
                    fontSize: 16.sp,
                  ),
            ),
            SizedBox(height: 8.h),
            Text(
              widget.message,
              style: TextStyle(
                color: AppColors.clr5D758F,
                fontSize: 13.sp,
                height: 1.35,
              ),
            ),
            SizedBox(height: 12.h),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _items.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final reasons = <String>[
                    if (item.priceMismatch) l10n.pharmacyCartItemPriceChanged,
                    if (item.outOfStock) l10n.pharmacyCartItemOutOfStock,
                  ];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: SizedBox(
                          width: 48.r,
                          height: 48.r,
                          child: PharmacyNetworkImage(
                            imageUrl: item.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                color: AppColors.clr060,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (reasons.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Text(
                                reasons.join(' · '),
                                style: TextStyle(
                                  color: AppColors.clrRed,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _removing.contains(item.productId)
                            ? null
                            : () => _remove(item),
                        child: Text(l10n.pharmacyRemoveFromCart),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),
            AppButtonWidget(
              title: l10n.pharmacyCartItemsInvalidAction,
              onTap: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
