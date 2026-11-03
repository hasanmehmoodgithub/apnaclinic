import 'package:flutter/foundation.dart';

/// Home AI flags shared outside the home tab.
///
/// Updated when the home panel loads. Consultation / home bot use [isEnabled]
/// (`data.aiEnabled`). Pharmacy prescription scan uses
/// [isPrescriptionEnabled] (`data.aiPrescriptionEnabled`).
class HomeAiEnabledSession extends ChangeNotifier {
  bool _enabled = false;
  bool _prescriptionEnabled = false;

  bool get isEnabled => _enabled;

  bool get isPrescriptionEnabled => _prescriptionEnabled;

  void setEnabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    notifyListeners();
  }

  void setPrescriptionEnabled(bool value) {
    if (_prescriptionEnabled == value) return;
    _prescriptionEnabled = value;
    notifyListeners();
  }

  void update({
    required bool aiEnabled,
    required bool aiPrescriptionEnabled,
  }) {
    final changed = _enabled != aiEnabled ||
        _prescriptionEnabled != aiPrescriptionEnabled;
    _enabled = aiEnabled;
    _prescriptionEnabled = aiPrescriptionEnabled;
    if (changed) notifyListeners();
  }
}
