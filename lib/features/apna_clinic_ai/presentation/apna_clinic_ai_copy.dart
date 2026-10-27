import '../../../../core/l10n/app_localizations.dart';
import '../domain/apna_clinic_ai_failure_codes.dart';

/// Display name used in UI (greeting rewrite, hero / chat header branding).
const apnaClinicAiDisplayName = 'Apna Clinic Ai Noor';

bool _isApnaClinicAiBrandAlias(String raw) {
  final compact = raw
      .replaceAll(RegExp(r'[\s_-]+'), ' ')
      .trim()
      .toLowerCase();
  final collapsed = compact.replaceAll(' ', '');
  return compact == 'noor' ||
      compact == 'apna clinic' ||
      compact == 'apnaclinic' ||
      compact == 'apnaclinic assistant' ||
      compact == 'apna clinic assistant' ||
      compact == 'apna clinic al noor' ||
      compact == 'apnaclinic al noor' ||
      compact == 'apna clinic ai noor' ||
      collapsed == 'apnaclinic' ||
      collapsed == 'apnaclinicassistant' ||
      collapsed == 'apnaclinicalnoor' ||
      collapsed == 'apnaclinicainoor';
}

/// Rewrites API assistant titles (e.g. "ApnaClinic Assistant", "Noor") to
/// [apnaClinicAiDisplayName].
String apnaClinicAiBrandName(String raw) {
  final value = raw.trim();
  if (value.isEmpty || _isApnaClinicAiBrandAlias(value)) {
    return apnaClinicAiDisplayName;
  }
  return value;
}

/// Rewrites greeting copy so short "noor" / old brand names become
/// [apnaClinicAiDisplayName].
String apnaClinicAiBrandGreeting(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return value;
  return value.replaceAllMapped(
    RegExp(
      r'\bapna\s*clinic\s*(al|ai)?\s*noor\b|\bapnaclinic\s+assistant\b|\bnoor\b',
      caseSensitive: false,
    ),
    (_) => apnaClinicAiDisplayName,
  );
}

String apnaClinicAiFailureText(AppLocalizations l10n, String? code) {
  switch (code) {
    case ApnaClinicAiFailureCodes.notConfigured:
      return l10n.apnaClinicAiNotConfigured;
    case ApnaClinicAiFailureCodes.upstream:
      return l10n.apnaClinicAiUpstream;
    case ApnaClinicAiFailureCodes.booking:
      return l10n.apnaClinicAiBookingFailed;
    case ApnaClinicAiFailureCodes.voiceUnavailable:
      return l10n.apnaClinicAiVoiceUnavailable;
    case ApnaClinicAiFailureCodes.emptyRecording:
    case ApnaClinicAiFailureCodes.noSpeech:
      return l10n.apnaClinicAiEmptyRecording;
    default:
      return l10n.apnaClinicAiConnectFailed;
  }
}

/// Rotating waiting lines for reply loading (bubble + header).
List<String> apnaClinicAiJustAMomentPhrases(AppLocalizations l10n) {
  return [
    l10n.apnaClinicAiJustAMoment,
    l10n.apnaClinicAiJustAMoment2,
    l10n.apnaClinicAiJustAMoment3,
  ];
}

String apnaClinicAiStageLabel(AppLocalizations l10n, String stage) {
  final key = stage.toLowerCase();
  switch (key) {
    case 'transcribing':
      return l10n.apnaClinicAiStageTranscribing;
    case 'router':
      return l10n.apnaClinicAiStageRouter;
    case 'capability':
      return l10n.apnaClinicAiStageCapability;
    case 'dispatch':
      return l10n.apnaClinicAiStageDispatch;
    case 'wf:browse':
    case 'browse':
      return l10n.apnaClinicAiStageBrowse;
    case 'wf:triage':
    case 'triage':
      return l10n.apnaClinicAiStageTriage;
    case 'tool':
      return l10n.apnaClinicAiStageTool;
    case 'writing':
      return l10n.apnaClinicAiStageWriting;
    case 'listening':
      return l10n.apnaClinicAiStageListening;
    default:
      return l10n.apnaClinicAiJustAMoment;
  }
}

String apnaClinicAiRelativeTime(AppLocalizations l10n, int savedAtMillis) {
  final elapsed = DateTime.now().difference(
    DateTime.fromMillisecondsSinceEpoch(savedAtMillis),
  );
  final mins = elapsed.inMinutes < 1 ? 1 : elapsed.inMinutes;
  if (mins < 60) return l10n.apnaClinicAiMinutesAgo(mins);
  final hours = elapsed.inHours < 1 ? 1 : elapsed.inHours;
  if (hours < 48) return l10n.apnaClinicAiHoursAgo(hours);
  final days = elapsed.inDays < 1 ? 1 : elapsed.inDays;
  return l10n.apnaClinicAiDaysAgo(days);
}
