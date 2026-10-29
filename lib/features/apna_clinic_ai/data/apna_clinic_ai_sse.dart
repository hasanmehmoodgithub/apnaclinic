import 'dart:convert';
import 'dart:typed_data';

bool isApnaClinicAiWav(List<int> bytes) {
  return bytes.length >= 4 &&
      bytes[0] == 0x52 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46 &&
      bytes[3] == 0x46;
}

/// Parses `text/event-stream` frames into JSON maps (`data: {...}` lines).
Stream<Map<String, dynamic>> parseApnaClinicAiSse(
  Stream<Uint8List> bytes,
) async* {
  final pending = StringBuffer();
  await for (final chunk in bytes) {
    pending.write(utf8.decode(chunk, allowMalformed: true));
    var text = pending.toString();
    while (true) {
      final split = text.indexOf('\n\n');
      if (split < 0) break;
      final frame = text.substring(0, split);
      text = text.substring(split + 2);
      String? dataLine;
      String? eventName;
      for (final rawLine in frame.split('\n')) {
        final line = rawLine.trim();
        if (line.startsWith('data:')) {
          dataLine ??= line.substring(5).trim();
        } else if (line.startsWith('event:')) {
          eventName = line.substring(6).trim();
        }
      }
      if (dataLine == null || dataLine.isEmpty) continue;
      try {
        final decoded = jsonDecode(dataLine);
        Map<String, dynamic>? event;
        if (decoded is Map<String, dynamic>) {
          event = decoded;
        } else if (decoded is Map) {
          event = Map<String, dynamic>.from(decoded);
        }
        if (event == null) continue;
        // `event: audio` is enough when the JSON body omits `type`.
        if ((event['type'] == null || event['type'].toString().isEmpty) &&
            eventName != null &&
            eventName.isNotEmpty) {
          event['type'] = eventName;
        }
        yield event;
      } catch (_) {}
    }
    pending
      ..clear()
      ..write(text);
  }
}
