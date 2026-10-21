import '../../domain/entities/prescription_extract_entity.dart';

class PrescriptionExtractModel {
  const PrescriptionExtractModel._();

  static PrescriptionExtractEntity fromJson(Map<String, dynamic> json) {
    final fields = _asMap(json['fields']) ?? json;
    return PrescriptionExtractEntity(
      pages: _asInt(json['pages']),
      type: _asString(fields['type']),
      date: _asString(fields['date']),
      doctor: _asString(fields['doctor']),
      patient: _asString(fields['patient']),
      institute: _asString(fields['institute']),
      location: _asString(fields['location']),
      isLabReport: _asBool(fields['is_lab_report']),
      medicines: _medicines(fields['medicines']),
      tests: _labels(fields['tests']),
    );
  }

  static Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String _asString(Object? value) => value?.toString().trim() ?? '';

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(_asString(value)) ?? 0;
  }

  static bool _asBool(Object? value) {
    if (value is bool) return value;
    final text = _asString(value).toLowerCase();
    return text == 'true' || text == '1' || text == 'yes';
  }

  static List<String> _labels(Object? value) {
    if (value is String) {
      return value
          .split(RegExp(r'[\n;]'))
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false);
    }
    if (value is! List) return const [];
    return value
        .map(_label)
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  static String _label(Object? value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      for (final key in ['name', 'test', 'test_name', 'title']) {
        final text = _asString(map[key]);
        if (text.isNotEmpty) return text;
      }
    }
    return _asString(value);
  }

  static List<PrescriptionMedicineEntity> _medicines(Object? value) {
    if (value is String) {
      return _labels(value)
          .map((name) => PrescriptionMedicineEntity(name: name))
          .toList(growable: false);
    }
    if (value is! List) return const [];
    return value
        .map(_medicine)
        .whereType<PrescriptionMedicineEntity>()
        .toList(growable: false);
  }

  static PrescriptionMedicineEntity? _medicine(Object? value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      final name = _firstString(map, const [
        'name',
        'medicine',
        'medicine_name',
        'drug',
        'drug_name',
        'display_name',
        'item',
      ]);
      if (name.isEmpty) return null;
      return PrescriptionMedicineEntity(
        name: name,
        dosage: _firstString(map, const ['dosage', 'dose', 'strength']),
        frequency: _firstString(map, const ['frequency', 'freq']),
        duration: _firstString(map, const [
          'duration',
          'days',
          'duration_days',
        ]),
        instructions: _firstString(map, const [
          'instructions',
          'instruction',
          'notes',
          'sig',
        ]),
        quantity: _asInt(
          map['quantity'] ?? map['qty'] ?? map['quantity_prescribed'],
        ),
      );
    }
    final name = _asString(value);
    if (name.isEmpty) return null;
    return PrescriptionMedicineEntity(name: name);
  }

  static String _firstString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final text = _asString(map[key]);
      if (text.isNotEmpty) return text;
    }
    return '';
  }
}
