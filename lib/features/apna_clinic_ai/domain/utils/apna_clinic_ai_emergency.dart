/// Critical-symptom check from the Apna Clinic AI demo.
class ApnaClinicAiEmergency {
  ApnaClinicAiEmergency._();

  static final RegExp _critical = RegExp(
    r"\b(can'?t\s+breathe|cannot\s+breathe|short(ness)?\s+of\s+breath|chest\s+pain|heart\s+attack|stroke|unconscious|not\s+waking|heavy\s+bleeding|severe\s+bleed|suicid|kill\s+myself|seizure|fitting|anaphyla|throat\s+swelling|blue\s+lips|passed\s+out|collapse[d]?|severe\s+pain\s+in\s+(my\s+)?heart)\b",
    caseSensitive: false,
  );

  static bool isCritical(String text) => _critical.hasMatch(text);
}
