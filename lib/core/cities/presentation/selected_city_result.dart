/// Result of [showSelectCityDialog] — city id + display name.
class SelectedCityResult {
  const SelectedCityResult({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}
