import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../../core/utils/microphone_permission_utils.dart';

/// Captures mic audio for the Jimi audio-stream turn (WAV preferred, M4A fallback).
class ApnaClinicAiAudioRecorderService {
  ApnaClinicAiAudioRecorderService({AudioRecorder? recorder})
    : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;
  DateTime? _startedAt;
  String? _path;
  var _isRecording = false;

  static const Duration minDuration = Duration(seconds: 1);

  /// Soft cap for voice notes (product limit for now).
  static const Duration maxDuration = Duration(seconds: 30);

  /// 16 kHz 16-bit mono for ~1s is ~32 KB. A few KB means the mic was not captured.
  static const int minBytes = 8000;

  bool get isRecording => _isRecording;

  Duration get elapsed {
    final started = _startedAt;
    if (started == null) return Duration.zero;
    return DateTime.now().difference(started);
  }

  Future<bool> start() async {
    if (_isRecording) return true;
    final granted = await ensureMicrophonePermission();
    if (!granted) return false;

    final dir = await getTemporaryDirectory();
    final fileName =
        'apna_clinic_ai_speech_${DateTime.now().millisecondsSinceEpoch}';

    RecordConfig config;
    String path;
    try {
      config = const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      );
      path = p.join(dir.path, '$fileName.wav');
      await _recorder.start(config, path: path);
    } catch (_) {
      config = const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,
        numChannels: 1,
        bitRate: 128000,
      );
      path = p.join(dir.path, '$fileName.m4a');
      await _recorder.start(config, path: path);
    }

    _path = path;
    _startedAt = DateTime.now();
    _isRecording = true;
    return true;
  }

  /// Stops and returns audio bytes, or `null` if too short / empty / cancelled.
  Future<Uint8List?> stop() async {
    if (!_isRecording) return null;
    _isRecording = false;
    final duration = elapsed;
    String? path;
    try {
      path = await _recorder.stop() ?? _path;
    } catch (_) {
      path = _path;
    }
    _startedAt = null;
    _path = null;

    if (path == null || path.isEmpty) return null;
    if (duration < minDuration) {
      await _deleteQuietly(path);
      return null;
    }

    try {
      final file = File(path);
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();
      await _deleteQuietly(path);
      if (bytes.length < minBytes) return null;
      return Uint8List.fromList(bytes);
    } catch (_) {
      await _deleteQuietly(path);
      return null;
    }
  }

  Future<void> cancel() async {
    if (!_isRecording && _path == null) return;
    _isRecording = false;
    _startedAt = null;
    try {
      await _recorder.cancel();
    } catch (_) {
      try {
        await _recorder.stop();
      } catch (_) {}
    }
    final path = _path;
    _path = null;
    if (path != null) await _deleteQuietly(path);
  }

  Future<void> dispose() async {
    await cancel();
    await _recorder.dispose();
  }

  Future<void> _deleteQuietly(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
