import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/functional/functional_export.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/app_update_prompt_entity.dart';
import '../repositories/dashboard_repository.dart';
import '../utils/app_version_comparator.dart';

class CheckAppUpdateUseCase
    implements UseCaseNoParams<AppUpdatePromptEntity?> {
  CheckAppUpdateUseCase({
    required this.repository,
    Future<PackageInfo> Function()? packageInfoLoader,
  }) : _packageInfoLoader = packageInfoLoader ?? PackageInfo.fromPlatform;

  final DashboardRepository repository;
  final Future<PackageInfo> Function() _packageInfoLoader;

  @override
  Future<Either<ErrorMsg, AppUpdatePromptEntity?>> call() async {
    final platform = _platformQueryValue();
    final result = await repository.getAppVersion(platform: platform);

    if (result.isLeft) {
      return Left(result.left);
    }

    final info = result.right;
    if (info == null) return const Right(null);

    final packageInfo = await _packageInfoLoader();
    final current = packageInfo.version.trim();
    final latest = info.latestVersion.trim();
    if (latest.isEmpty || current.isEmpty) {
      return const Right(null);
    }

    final minimum = info.minimumVersion?.trim();
    final belowMinimum = minimum != null &&
        minimum.isNotEmpty &&
        AppVersionComparator.isOlderThan(current, minimum);
    final belowLatest = AppVersionComparator.isOlderThan(current, latest);
    if (!belowLatest && !belowMinimum) {
      return const Right(null);
    }

    // CMS `isForceUpgrade` or installed version below `minVersion`.
    final forceUpdate = info.forceUpdate || belowMinimum;
    final storeUrl = info.storeUrl.trim().isNotEmpty
        ? info.storeUrl.trim()
        : _fallbackStoreUrl(packageInfo.packageName);

    return Right(
      AppUpdatePromptEntity(
        forceUpdate: forceUpdate,
        latestVersion: latest,
        currentVersion: current,
        storeUrl: storeUrl,
        title: info.title,
        message: info.message,
      ),
    );
  }

  String _platformQueryValue() {
    if (kIsWeb) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'android';
  }

  String _fallbackStoreUrl(String packageName) {
    if (!kIsWeb && Platform.isIOS) {
      return AppUrls.apnaClinicAppStoreIos;
    }
    if (packageName.trim().isNotEmpty) {
      return 'https://play.google.com/store/apps/details?id=$packageName';
    }
    return AppUrls.apnaClinicPlayStoreAndroid;
  }
}
