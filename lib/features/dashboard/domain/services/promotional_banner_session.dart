import '../../../../core/enums/state_status.dart';
import '../entities/promotional_banner_entity.dart';
import '../use_cases/promotional_banner_use_case.dart';

/// Fetches and caches the promotional banner for the app session.
/// API is called on cold start and after login — not on logout tab remounts.
class PromotionalBannerSession {
  PromotionalBannerSession({required this.getPromotionalBannerUseCase});

  final GetPromotionalBannerUseCase getPromotionalBannerUseCase;

  PromotionalBannerEntity? _banner;
  StateStatus _loadingStateStatus = StateStatus.idle;
  String? _errorMessage;
  bool _hasLoaded = false;
  bool dialogShown = false;
  Future<void>? _inFlight;

  bool get hasLoaded => _hasLoaded;

  bool get isLoading => _loadingStateStatus == StateStatus.loading;

  StateStatus get loadingStateStatus => _loadingStateStatus;

  String? get errorMessage => _errorMessage;

  PromotionalBannerEntity? get banner => _banner;

  Future<void> ensureLoaded() {
    if (_hasLoaded) return Future.value();
    return reload();
  }

  Future<void> reload() {
    return _inFlight ??= _fetchBanner();
  }

  Future<void> _fetchBanner() async {
    _loadingStateStatus = StateStatus.loading;
    _errorMessage = null;

    final result = await getPromotionalBannerUseCase.call();
    result.fold(
      (error) {
        _banner = null;
        _loadingStateStatus = StateStatus.error;
        _errorMessage = error;
        _hasLoaded = true;
      },
      (banner) {
        _banner = banner;
        _loadingStateStatus = banner.showBanner
            ? StateStatus.success
            : StateStatus.empty;
        _errorMessage = null;
        _hasLoaded = true;
      },
    );
    _inFlight = null;
  }

  void resetDialogShown() {
    dialogShown = false;
  }

  void markDialogShown() {
    dialogShown = true;
  }

  void prepareForLoginRefresh() {
    _hasLoaded = false;
    _banner = null;
    _loadingStateStatus = StateStatus.idle;
    _errorMessage = null;
    _inFlight = null;
    dialogShown = false;
  }
}
