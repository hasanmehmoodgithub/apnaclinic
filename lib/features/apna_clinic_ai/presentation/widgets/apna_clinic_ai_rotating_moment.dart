import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../apna_clinic_ai_copy.dart';

/// Cycles Just a moment / Looking into that / Almost ready every 3s.
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

class _ApnaClinicAiRotatingMomentState extends State<ApnaClinicAiRotatingMoment> {
  Timer? _timer;
  var _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % 3);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phrases = apnaClinicAiJustAMomentPhrases(
      AppLocalizations.of(context)!,
    );
    final phrase = phrases[_index % phrases.length];
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
  }
}
