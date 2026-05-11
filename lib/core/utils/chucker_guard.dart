class ChuckerGuard {
  static const bool _flagPrimary =
      bool.fromEnvironment('CHUCKER_ACTIVE', defaultValue: false);
  static bool get isEnabled => _flagPrimary;
}
