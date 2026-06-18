/// Arguments for launching [SearchScreen] via `go_router` `extra`.
class SearchLaunchArgs {
  const SearchLaunchArgs({
    this.initialQuery,
    this.startVoiceSearch = false,
  });

  final String? initialQuery;
  final bool startVoiceSearch;
}
