import '../../../../generated/assets.dart';
import '../../domain/entities/search_entity.dart';

String sectionIconAsset(SearchSectionType type) {
  switch (type) {
    case SearchSectionType.doctorConsultation:
      return Assets.iconsDoctor;
    case SearchSectionType.pharmacy:
      return Assets.iconsPharmacy;
    case SearchSectionType.laboratoryTests:
      return Assets.iconsTest;
    case SearchSectionType.surgeryBooking:
      return Assets.iconsBooking;
  }
}
