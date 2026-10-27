import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../apna_clinic_ai_copy.dart';

/// Cycles Just a moment / Looking into that / Almost ready every 3s.
/// Timer drives a [StreamBuilder] — no [setState].
class ApnaClinicAiRotatingMoment extends StatefulWidget {
  const ApnaClinicAiRotatingMoment({
    super.key,
    required this.style,
    this.maxLines = 1,
  });

  final TextStyle style;
  final int maxLines;

  @override
  State<ApnaClinicAiRotatingMoment> createState() =>
      _ApnaClinicAiRotatingMomentState();
}

class _ApnaClinicAiRotatingMomentState
    extends State<ApnaClinicAiRotatingMoment> {
  late final StreamController<int> _ticks;
  Timer? _timer;
  var _index = 0;

  @override
  void initState() {
    super.initState();
    _ticks = StreamController<int>.broadcast();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _index = (_index + 1) % 3;
      if (!_ticks.isClosed) _ticks.add(_index);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_ticks.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phrases = apnaClinicAiJustAMomentPhrases(
      AppLocalizations.of(context)!,
    );
    return StreamBuilder<int>(
      stream: _ticks.stream,
      initialData: 0,
      builder: (context, snap) {
        final phrase = phrases[(snap.data ?? 0) % phrases.length];
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: Text(
            phrase,
            key: ValueKey<String>(phrase),
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
            style: widget.style,
          ),
        );
      },
    );
  }
}
