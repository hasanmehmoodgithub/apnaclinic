import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../domain/entities/pharmacy_city_entity.dart';
import 'cubit/pharmacy_cubit.dart';
import 'widgets/pharmacy_city_select_dialog.dart';

/// Opens the pharmacy city picker. Returns `true` if a city is confirmed.
Future<bool> openPharmacyCityPicker(
  BuildContext context, {
  required bool barrierDismissible,
  bool reloadCatalog = true,
}) async {
  final cubit = context.read<PharmacyCubit>();
  final l10n = AppLocalizations.of(context)!;
  final previousCity = cubit.state.selectedCity.trim();
  final hasCartItems = cubit.state.cartItems.isNotEmpty;

  final initial = _initialSelected(cubit);
  final picked = await showPharmacyCitySelectDialog(
    context,
    loadCities: cubit.fetchPharmacyCities,
    cities: cubit.state.pharmacyCities.isNotEmpty
        ? cubit.state.pharmacyCities
        : null,
    initialSelected: initial,
    barrierDismissible: barrierDismissible,
    cartSwitchHint: hasCartItems && previousCity.isNotEmpty
        ? l10n.pharmacyCityCartSwitchHint(previousCity)
        : null,
  );

  if (!context.mounted) return cubit.hasPharmacyCity;
  if (picked == null) {
    if (!barrierDismissible) {
      // Back / dismiss on required picker exits pharmacy.
      if (context.canPop()) {
        context.pop();
      }
      return false;
    }
    return cubit.hasPharmacyCity;
  }

  await cubit.confirmPharmacyCity(picked, reloadCatalog: reloadCatalog);
  return true;
}

PharmacyCityEntity? _initialSelected(PharmacyCubit cubit) {
  final id = cubit.state.pharmacyCityId;
  final name = cubit.state.selectedCity.trim();
  if (id == null || id <= 0 || name.isEmpty) return null;
  for (final city in cubit.state.pharmacyCities) {
    if (city.id == id) return city;
  }
  return PharmacyCityEntity(
    id: id,
    name: name,
    partner: cubit.state.pharmacyPartner,
  );
}
