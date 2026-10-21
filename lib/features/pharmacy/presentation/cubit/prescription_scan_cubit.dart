import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/prescription_extract_entity.dart';
import '../../domain/use_cases/extract_prescription_params.dart';
import '../../domain/use_cases/extract_prescription_use_case.dart';
import '../../domain/use_cases/get_pharmacy_medicines_use_case.dart';
import '../../domain/utils/prescription_catalog_query.dart';
import 'prescription_scan_state.dart';

class PrescriptionScanCubit extends Cubit<PrescriptionScanState> {
  PrescriptionScanCubit({
    required this.extractPrescriptionUseCase,
    required this.getPharmacyMedicinesUseCase,
  }) : super(const PrescriptionScanState());

  final ExtractPrescriptionUseCase extractPrescriptionUseCase;
  final GetPharmacyMedicinesUseCase getPharmacyMedicinesUseCase;

  void setImage(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) return;
    emit(
      state.copyWith(
        imagePath: trimmed,
        extracting: false,
        clearError: true,
        clearResult: true,
        matches: const [],
      ),
    );
  }

  Future<void> extract() async {
    final path = state.imagePath?.trim() ?? '';
    if (path.isEmpty || state.extracting) return;

    emit(state.copyWith(extracting: true, clearError: true));
    final result = await extractPrescriptionUseCase(
      ExtractPrescriptionParams(filePath: path),
    );
    if (isClosed) return;

    await result.fold(
      (error) async {
        emit(state.copyWith(extracting: false, errorCode: error));
      },
      (entity) async {
        emit(
          state.copyWith(
            extracting: false,
            result: entity,
            matches: List<PrescriptionMedicineMatch>.generate(
              entity.medicines.length,
              (_) => const PrescriptionMedicineMatch(loading: true),
            ),
            clearError: true,
          ),
        );
        final matches = await Future.wait(entity.medicines.map(_search));
        if (isClosed) return;
        emit(state.copyWith(matches: matches));
      },
    );
  }

  Future<PrescriptionMedicineMatch> _search(
    PrescriptionMedicineEntity medicine,
  ) async {
    final query = prescriptionCatalogQuery(medicine.name);
    if (query.isEmpty) return const PrescriptionMedicineMatch();

    final result = await getPharmacyMedicinesUseCase(
      GetPharmacyMedicinesParams(page: 1, displayName: query),
    );
    return result.fold(
      (_) => const PrescriptionMedicineMatch(),
      (page) => PrescriptionMedicineMatch(
        products: page.items.take(3).toList(growable: false),
      ),
    );
  }
}
