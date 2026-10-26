import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class ApnaClinicAiPlaybackSnapshot {
  const ApnaClinicAiPlaybackSnapshot({
    this.messageId,
    this.playing = false,
  });

  final String? messageId;
  final bool playing;

  bool get active => messageId != null;

  @override
  bool operator ==(Object other) {
    return other is ApnaClinicAiPlaybackSnapshot &&
        other.messageId == messageId &&
        other.playing == playing;
  }

  @override
  int get hashCode => Object.hash(messageId, playing);
}

/// Plays assistant TTS (`audio.base64`) or device speech for reply text.
class ApnaClinicAiAudioPlayerService {
  ApnaClinicAiAudioPlayerService({AudioPlayer? player, FlutterTts? tts})
    : _player = player ?? AudioPlayer(),
      _tts = tts ?? FlutterTts() {
    _stateSub = _player.playerStateStream.listen(_onPlayerState);
    _positionSub = _player.positionStream.listen(_onPosition);
    _processingSub = _player.processingStateStream.listen(_onProcessing);
    unawaited(_wireTts());
  }

  final AudioPlayer _player;
  final FlutterTts _tts;
  final _states = StreamController<ApnaClinicAiPlaybackSnapshot>.broadcast();
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<ProcessingState>? _processingSub;
  String? _currentKey;
  var _ttsPlaying = false;
  var _ttsPaused = false;
  String? _ttsText;
  var _snapshot = const ApnaClinicAiPlaybackSnapshot();
  /// True after [playBase64] starts; cleared on natural completion / stop.
  var _fileClipLive = false;
  /// Latched when position hits the end (some platforms then seek to 0).
  var _clipReachedEnd = false;

  void _onPlayerState(PlayerState state) {
    _noteEndIfNeeded(state.processingState);
    if (_shouldDismissFileClip(
      playing: state.playing,
      processing: state.processingState,
    )) {
      _dismissFileClip();
    }
    _publish();
  }

  void _onPosition(Duration _) {
    _noteEndIfNeeded(_player.processingState);
    if (_shouldDismissFileClip(
      playing: _player.playing,
      processing: _player.processingState,
    )) {
      _dismissFileClip();
      _publish();
    }
  }

  void _onProcessing(ProcessingState processing) {
    _noteEndIfNeeded(processing);
    if (_shouldDismissFileClip(
      playing: _player.playing,
      processing: processing,
    )) {
      _dismissFileClip();
      _publish();
    }
  }

  void _noteEndIfNeeded(ProcessingState processing) {
    if (!_fileClipLive) return;
    if (processing == ProcessingState.completed || _isClipNearEnd()) {
      _clipReachedEnd = true;
    }
  }

  void _dismissFileClip() {
    _fileClipLive = false;
    _clipReachedEnd = false;
    _currentKey = null;
    // Clear a stuck playing flag so the speaking bar hides immediately.
    unawaited(() async {
      try {
        if (_player.playing) await _player.pause();
      } catch (_) {}
    }());
  }

  /// Dismiss when the clip finishes. Mid-clip pause keeps the bar.
  /// Handles platforms that emit `completed`, stay at `ready` near end, or
  /// seek back to 0 after end (via [_clipReachedEnd]).
  bool _shouldDismissFileClip({
    required bool playing,
    required ProcessingState processing,
  }) {
    if (!_fileClipLive) return false;
    if (processing == ProcessingState.completed) return true;
    if (playing) return false;
    return _clipReachedEnd || _isClipNearEnd();
  }

  bool _isClipNearEnd() {
    final duration = _player.duration;
    if (duration == null || duration.inMilliseconds <= 0) return false;
    return duration - _player.position <= const Duration(milliseconds: 400);
  }

  bool get isPlaying => _player.playing || _ttsPlaying;

  ApnaClinicAiPlaybackSnapshot get snapshot => _snapshot;

  Stream<ApnaClinicAiPlaybackSnapshot> get snapshots => _states.stream;

  Future<void> _wireTts() async {
    try {
      await _tts.setSpeechRate(0.48);
      _tts.setStartHandler(() {
        _ttsPlaying = true;
        _ttsPaused = false;
        _publish();
      });
      _tts.setCompletionHandler(() {
        _ttsPlaying = false;
        _ttsPaused = false;
        _ttsText = null;
        _currentKey = null;
        _publish();
      });
      _tts.setCancelHandler(() {
        _ttsPlaying = false;
        _ttsPaused = false;
        _ttsText = null;
        _currentKey = null;
        _publish();
      });
      _tts.setPauseHandler(() {
        _ttsPlaying = false;
        _ttsPaused = true;
        _publish();
      });
      _tts.setContinueHandler(() {
        _ttsPlaying = true;
        _ttsPaused = false;
        _publish();
      });
      _tts.setErrorHandler((_) {
        _ttsPlaying = false;
        _ttsPaused = false;
        _ttsText = null;
        _currentKey = null;
        _publish();
      });
    } catch (_) {}
  }

  Future<void> stop() async {
    _fileClipLive = false;
    _clipReachedEnd = false;
    _currentKey = null;
    _ttsPlaying = false;
    _ttsPaused = false;
    _ttsText = null;
    try {
      await _tts.stop();
    } catch (_) {}
    try {
      await _player.stop();
    } catch (_) {}
    _publish();
  }

  Future<void> pause() async {
    try {
      if (_player.playing) await _player.pause();
    } catch (_) {}
    try {
      if (_ttsPlaying) {
        await _tts.pause();
        _ttsPlaying = false;
        _ttsPaused = true;
      }
    } catch (_) {}
    _publish();
  }

  Future<void> resume() async {
    final processing = _player.processingState;
    final hasFile =
        processing != ProcessingState.idle &&
        processing != ProcessingState.completed;
    if (hasFile) {
      try {
        await _player.play();
      } catch (_) {}
      return;
    }
    final spoken = (_ttsText ?? '').trim();
    if (spoken.isEmpty) return;
    try {
      await _tts.speak(spoken);
      _ttsPlaying = true;
      _ttsPaused = false;
      _publish();
    } catch (_) {}
  }

  /// Plays server audio when present; otherwise speaks [text] on device.
  Future<void> toggleAssistant({
    required String messageId,
    String? base64Audio,
    String? mediaType,
    required String text,
  }) async {
    final clip = (base64Audio ?? '').trim();
    if (clip.isNotEmpty) {
      await toggleMessage(
        messageId: messageId,
        base64Audio: clip,
        mediaType: mediaType,
      );
      return;
    }
    await toggleText(messageId: messageId, text: text);
  }

  /// Plays [base64] for [messageId], or pauses / resumes that same clip.
  Future<void> toggleMessage({
    required String messageId,
    required String base64Audio,
    String? mediaType,
  }) async {
    final sameClip = _currentKey == messageId && _snapshot.active;
    if (sameClip && isPlaying) {
      await pause();
      return;
    }
    if (sameClip && !isPlaying) {
      await resume();
      return;
    }
    await playBase64(base64Audio, mediaType: mediaType, messageId: messageId);
  }

  Future<void> toggleText({
    required String messageId,
    required String text,
  }) async {
    final spoken = _plainSpeech(text);
    if (spoken.isEmpty) return;
    final sameClip = _currentKey == messageId && _snapshot.active;
    if (sameClip && _ttsPlaying) {
      await pause();
      return;
    }
    if (sameClip && _ttsPaused) {
      _ttsText = spoken;
      await resume();
      return;
    }
    try {
      await _tts.stop();
      await _player.stop();
    } catch (_) {}
    _currentKey = messageId;
    _ttsText = spoken;
    _ttsPlaying = true;
    _ttsPaused = false;
    _publish();
    try {
      await _tts.speak(spoken);
    } catch (_) {
      _ttsPlaying = false;
      _ttsPaused = false;
      _ttsText = null;
      _currentKey = null;
      _publish();
    }
  }

  void _publish() {
    final processing = _player.processingState;
    if (_shouldDismissFileClip(
      playing: _player.playing,
      processing: processing,
    )) {
      _dismissFileClip();
    }
    // Gate on [_fileClipLive] so a stuck `ready` after end can't keep the bar.
    final fileBusy = _fileClipLive &&
        _currentKey != null &&
        (processing == ProcessingState.loading ||
            processing == ProcessingState.buffering ||
            processing == ProcessingState.ready ||
            _player.playing);
    final active =
        _currentKey != null && (_ttsPlaying || _ttsPaused || fileBusy);
    final next = ApnaClinicAiPlaybackSnapshot(
      messageId: active ? _currentKey : null,
      playing:
          active &&
          (_ttsPlaying ||
              _player.playing ||
              processing == ProcessingState.loading ||
              processing == ProcessingState.buffering),
    );
    if (next == _snapshot) return;
    _snapshot = next;
    if (!_states.isClosed) _states.add(next);
  }

  Future<void> playBase64(
    String base64Audio, {
    String? mediaType,
    String? messageId,
  }) async {
    try {
      final bytes = base64Decode(base64Audio);
      if (bytes.isEmpty) return;
      try {
        await _tts.stop();
      } catch (_) {}
      _ttsPlaying = false;
      _ttsPaused = false;
      _ttsText = null;
      _fileClipLive = false;
      _clipReachedEnd = false;
      final dir = await getTemporaryDirectory();
      final ext = _audioExtension(bytes, mediaType);
      final file = File(
        '${dir.path}/apna_clinic_ai_reply_${DateTime.now().microsecondsSinceEpoch}.$ext',
      );
      await file.writeAsBytes(bytes, flush: true);
      await _player.stop();
      await _player.setFilePath(file.path);
      await _player.setVolume(1);
      // Mark live only after load so prior completed/idle events can't dismiss.
      _currentKey = messageId;
      _fileClipLive = true;
      _clipReachedEnd = false;
      await _player.play();
      _publish();
    } catch (_) {
      _fileClipLive = false;
      _clipReachedEnd = false;
      _currentKey = null;
      _publish();
    }
  }

  Future<void> dispose() async {
    await _stateSub?.cancel();
    await _positionSub?.cancel();
    await _processingSub?.cancel();
    await _states.close();
    try {
      await _tts.stop();
    } catch (_) {}
    await _player.dispose();
  }

  String _plainSpeech(String raw) {
    var text = raw.trim();
    if (text.isEmpty) return '';
    text = text.replaceAll(RegExp(r'!\[[^\]]*]\([^)]*\)'), ' ');
    text = text.replaceAllMapped(
      RegExp(r'\[([^\]]+)\]\([^)]*\)'),
      (match) => match.group(1) ?? '',
    );
    text = text.replaceAll(RegExp(r'\*\*|__|`'), '');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text;
  }

  String _audioExtension(List<int> bytes, String? mediaType) {
    final type = (mediaType ?? '').toLowerCase();
    if (type.contains('mpeg') || type.contains('mp3')) return 'mp3';
    if (type.contains('ogg') || type.contains('opus')) return 'ogg';
    if (type.contains('wav')) return 'wav';
    if (type.contains('mp4') || type.contains('m4a') || type.contains('aac')) {
      return 'm4a';
    }
    if (bytes.length >= 4) {
      final wav =
          bytes[0] == 0x52 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x46;
      final ogg =
          bytes[0] == 0x4F &&
          bytes[1] == 0x67 &&
          bytes[2] == 0x67 &&
          bytes[3] == 0x53;
      if (wav) return 'wav';
      if (ogg) return 'ogg';
      if (bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33) {
        return 'mp3';
      }
      if (bytes[0] == 0xFF && (bytes[1] & 0xE0) == 0xE0) return 'mp3';
    }
    return 'm4a';
  }
}
