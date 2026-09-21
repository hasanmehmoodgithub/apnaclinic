import 'dart:math';

import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/consultation_repository.dart';

class RecordAiAssistantInteractionParams {
  const RecordAiAssistantInteractionParams({
    required this.sessionId,
    required this.startedAt,
    required this.durationSeconds,
  });

  static const maxSessionIdLength = 64;
  static const maxDurationSeconds = 86400;

  final String sessionId;
  final DateTime startedAt;
  final int durationSeconds;

  /// `{userId}-{uuid}`, truncated to [maxSessionIdLength].
  static String buildSessionId(String userId) {
    final trimmedUserId = userId.trim();
    final randomId = _randomUuidV4();
    final raw = trimmedUserId.isEmpty ? randomId : '$trimmedUserId-$randomId';
    if (raw.length <= maxSessionIdLength) return raw;
    return raw.substring(0, maxSessionIdLength);
  }

  static int clampDuration(int seconds) {
    if (seconds < 0) return 0;
    if (seconds > maxDurationSeconds) return maxDurationSeconds;
    return seconds;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'session_id': sessionId,
        'started_at': _iso8601WithOffset(startedAt),
        'duration_seconds': clampDuration(durationSeconds),
      };
}

class RecordAiAssistantInteractionUseCase
    implements UseCase<void, RecordAiAssistantInteractionParams> {
  RecordAiAssistantInteractionUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(
    RecordAiAssistantInteractionParams params,
  ) {
    return repository.recordAiAssistantInteraction(params);
  }
}

String _randomUuidV4() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  String hex(int index) => bytes[index].toRadixString(16).padLeft(2, '0');
  return '${hex(0)}${hex(1)}${hex(2)}${hex(3)}-'
      '${hex(4)}${hex(5)}-'
      '${hex(6)}${hex(7)}-'
      '${hex(8)}${hex(9)}-'
      '${hex(10)}${hex(11)}${hex(12)}${hex(13)}${hex(14)}${hex(15)}';
}

/// Local instant with numeric offset (e.g. `2026-09-18T14:05:22+05:00`).
String _iso8601WithOffset(DateTime dateTime) {
  final local = dateTime.toLocal();
  final offset = local.timeZoneOffset;
  final sign = offset.isNegative ? '-' : '+';
  final hours = offset.inHours.abs().toString().padLeft(2, '0');
  final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
  String two(int value) => value.toString().padLeft(2, '0');
  return '${local.year.toString().padLeft(4, '0')}-'
      '${two(local.month)}-'
      '${two(local.day)}T'
      '${two(local.hour)}:'
      '${two(local.minute)}:'
      '${two(local.second)}'
      '$sign$hours:$minutes';
}
