import '../../../../core/l10n/app_localizations.dart';
import '../domain/apna_clinic_ai_failure_codes.dart';

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
      return l10n.apnaClinicAiEmptyRecording;
    default:
      return l10n.apnaClinicAiConnectFailed;
  }
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
      if (key.startsWith('wf:')) return l10n.apnaClinicAiStageDoctors;
      return l10n.apnaClinicAiStageSpecialists;
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
