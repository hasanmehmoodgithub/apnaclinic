import '../../domain/entities/app_version_info_entity.dart';
import '../models/app_version_model.dart';

class AppVersionMapper {
  static AppVersionInfoEntity? toEntity(AppVersionResponseModel model) {
    if (!model.success || !model.version.hasVersion) return null;
    final v = model.version;
    return AppVersionInfoEntity(
      latestVersion: v.latestVersion.trim(),
      minimumVersion: v.minimumVersion?.trim(),
      forceUpdate: v.forceUpdate,
      storeUrl: v.storeUrl.trim(),
      title: v.title?.trim(),
      message: v.message?.trim(),
    );
  }
}
