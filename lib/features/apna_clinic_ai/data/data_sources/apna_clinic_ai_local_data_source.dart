import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class ApnaClinicAiComplaint {
  const ApnaClinicAiComplaint({required this.text, required this.savedAtMillis});

  final String text;
  final int savedAtMillis;
}

abstract class ApnaClinicAiLocalDataSource {
  Future<String> deviceId();

  Future<void> saveComplaint(String text);

  ApnaClinicAiComplaint? readComplaint();
}

class ApnaClinicAiLocalDataSourceImpl implements ApnaClinicAiLocalDataSource {
  ApnaClinicAiLocalDataSourceImpl({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  static const _deviceKey = 'apna_clinic_ai.device_id';
  static const _complaintKey = 'apna_clinic_ai.last_complaint';

  @override
  Future<String> deviceId() async {
    final existing = _preferences.getString(_deviceKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final random = Random.secure();
    final id = List<int>.generate(12, (_) => random.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    final deviceId = 'ac-$id';
    await _preferences.setString(_deviceKey, deviceId);
    return deviceId;
  }

  @override
  Future<void> saveComplaint(String text) async {
    final trimmed = text.trim();
    if (trimmed.length < 8) return;
    final payload = jsonEncode({
      'text': trimmed.length > 120 ? trimmed.substring(0, 120) : trimmed,
      'when': DateTime.now().millisecondsSinceEpoch,
    });
    await _preferences.setString(_complaintKey, payload);
  }

  @override
  ApnaClinicAiComplaint? readComplaint() {
    final raw = _preferences.getString(_complaintKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      final text = decoded['text']?.toString().trim() ?? '';
      final when = decoded['when'];
      if (text.isEmpty || when is! num) return null;
      return ApnaClinicAiComplaint(text: text, savedAtMillis: when.toInt());
    } catch (_) {
      return null;
    }
  }
}
