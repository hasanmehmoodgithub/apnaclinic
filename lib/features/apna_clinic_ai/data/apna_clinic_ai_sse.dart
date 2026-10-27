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
      for (final line in frame.split('\n')) {
        if (line.startsWith('data: ')) {
          dataLine = line.substring(6);
          break;
        }
      }
      if (dataLine == null || dataLine.isEmpty) continue;
      try {
        final decoded = jsonDecode(dataLine);
        if (decoded is Map<String, dynamic>) {
          yield decoded;
        } else if (decoded is Map) {
          yield Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }
    pending
      ..clear()
      ..write(text);
  }
}
