/// Client-side decision to prompt the user to update.
class AppUpdatePromptEntity {
  const AppUpdatePromptEntity({
    required this.forceUpdate,
    required this.latestVersion,
    required this.currentVersion,
    required this.storeUrl,
    this.title,
    this.message,
  });

  final bool forceUpdate;
  final String latestVersion;
  final String currentVersion;
  final String storeUrl;
  final String? title;
  final String? message;
}
