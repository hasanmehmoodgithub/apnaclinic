import 'package:equatable/equatable.dart';

import '../../domain/entities/pharmacy_medicine_entity.dart';
import '../../domain/entities/prescription_extract_entity.dart';

class PrescriptionMedicineMatch extends Equatable {
  const PrescriptionMedicineMatch({
    this.loading = false,
    this.products = const [],
  });

  final bool loading;
  final List<PharmacyMedicineEntity> products;

  @override
  List<Object?> get props => [loading, products];
}

class PrescriptionScanState extends Equatable {
  const PrescriptionScanState({
    this.imagePath,
    this.extracting = false,
    this.errorCode,
    this.result,
    this.matches = const [],
  });

  final String? imagePath;
  final bool extracting;
  final String? errorCode;
  final PrescriptionExtractEntity? result;
  final List<PrescriptionMedicineMatch> matches;

  PrescriptionScanState copyWith({
    String? imagePath,
    bool clearImage = false,
    bool? extracting,
    String? errorCode,
    bool clearError = false,
    PrescriptionExtractEntity? result,
    bool clearResult = false,
    List<PrescriptionMedicineMatch>? matches,
  }) {
    return PrescriptionScanState(
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      extracting: extracting ?? this.extracting,
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      result: clearResult ? null : (result ?? this.result),
      matches: matches ?? this.matches,
    );
  }

  @override
  List<Object?> get props => [
    imagePath,
    extracting,
    errorCode,
    result,
    matches,
  ];
}
