/// Remote CMS app-version payload for the current platform.
class AppVersionInfoEntity {
  const AppVersionInfoEntity({
    required this.latestVersion,
    required this.forceUpdate,
    required this.storeUrl,
    this.minimumVersion,
    this.title,
    this.message,
  });

  final String latestVersion;
  final String? minimumVersion;
  final bool forceUpdate;
  final String storeUrl;
  final String? title;
  final String? message;
}
