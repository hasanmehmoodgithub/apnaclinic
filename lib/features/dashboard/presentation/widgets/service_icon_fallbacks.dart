import '../../../../generated/assets.dart';

/// Bundled service icons used when CMS SVG wrappers fail to render.
String? serviceIconFallbackAsset(String? route) {
  if (route == null || route.isEmpty) return null;

  switch (route) {
    case 'consultation':
      return Assets.servicesOnlineConsultation;
    case 'pharmacyMain':
      return Assets.servicesPharmacy;
    case 'labTest':
      return Assets.servicesLaboratory;
    case 'surgery':
      return Assets.servicesSurgeryBooking;
    default:
      return null;
  }
}
