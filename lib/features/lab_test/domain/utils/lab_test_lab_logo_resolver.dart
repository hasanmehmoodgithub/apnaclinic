import '../../../../generated/assets.dart';

class LabTestLabLogoResolver {
  LabTestLabLogoResolver._();

  static String logoUrlForLab({required String labSlug, required String labName}) {
    final key = '${labSlug.toLowerCase()} ${labName.toLowerCase()}';
    if (key.contains('idc')) return Assets.labTestIDCLogo;
    if (key.contains('chughtai')) return Assets.labTestChughtaiLabLogo;
    if (key.contains('nayab') || key.contains('naya')) return Assets.labTestNayaLabLogo;
    if (key.contains('excel')) return Assets.labTestExcelLabLogo;
    if (key.contains('shaukat')) return Assets.labTestChughtaiLabLogo;
    if (key.contains('united')) return Assets.labTestIDCLogo;
    return '';
  }
}
