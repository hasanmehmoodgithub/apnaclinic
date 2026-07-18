import '../../../../core/enums/state_status.dart';
import '../entities/promotional_banner_entity.dart';
import '../use_cases/promotional_banner_use_case.dart';

/// Holds promotional banners for home display. Fetched only from dashboard
/// (`DashboardCubit.syncPromotionalBannerFromSession`), not on app start.
class PromotionalBannerSession {
  PromotionalBannerSession({required this.getPromotionalBannerUseCase});

  final GetPromotionalBannerUseCase getPromotionalBannerUseCase;

  List<PromotionalBannerEntity> _banners = const [];
  int _nextIndex = 0;
  StateStatus _loadingStateStatus = StateStatus.idle;
  String? _errorMessage;
  bool _hasLoaded = false;
  Future<void>? _inFlight;

  bool get hasLoaded => _hasLoaded;

  bool get isLoading => _loadingStateStatus == StateStatus.loading;

  StateStatus get loadingStateStatus => _loadingStateStatus;

  String? get errorMessage => _errorMessage;

  List<PromotionalBannerEntity> get banners => _banners;

  /// Next banner to show, or null when the queue is finished / empty.
  PromotionalBannerEntity? get nextBanner {
    if (_nextIndex < 0 || _nextIndex >= _banners.length) return null;
    return _banners[_nextIndex];
  }

  bool get hasPendingBanners => nextBanner != null;

  /// True once every banner in the current session queue has been dismissed.
  bool get queueFinished => _hasLoaded && _nextIndex >= _banners.length;

  /// Legacy single-banner accessor — current/next item in the queue.
  PromotionalBannerEntity? get banner => nextBanner;

  /// Kept for older call sites; queue progress is tracked via [_nextIndex].
  bool get dialogShown => queueFinished && _banners.isNotEmpty;

  Future<void> ensureLoaded() {
    if (_hasLoaded) return Future.value();
    return reload();
  }

  /// Always hits the banners API and resets the display queue.
  Future<void> reload() {
    return _inFlight ??= _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    _loadingStateStatus = StateStatus.loading;
    _errorMessage = null;
    _nextIndex = 0;

    final result = await getPromotionalBannerUseCase.call();
    result.fold(
      (error) {
        _banners = const [];
        _loadingStateStatus = StateStatus.error;
        _errorMessage = error;
        _hasLoaded = true;
        _nextIndex = 0;
      },
      (banners) {
        _banners = banners
            .where((b) => b.showBanner && b.url.trim().isNotEmpty)
            .toList(growable: false);
        _loadingStateStatus =
            _banners.isNotEmpty ? StateStatus.success : StateStatus.empty;
        _errorMessage = null;
        _hasLoaded = true;
        _nextIndex = 0;
      },
    );
    _inFlight = null;
  }

  void advanceQueue() {
    if (_nextIndex < _banners.length) {
      _nextIndex++;
    }
  }

  void resetDialogShown() {
    _nextIndex = 0;
  }

  void markDialogShown() {
    // Marks the whole queue finished (legacy single-dialog callers).
    _nextIndex = _banners.length;
  }

  void prepareForLoginRefresh() {
    _hasLoaded = false;
    _banners = const [];
    _nextIndex = 0;
    _loadingStateStatus = StateStatus.idle;
    _errorMessage = null;
    _inFlight = null;
  }
}
