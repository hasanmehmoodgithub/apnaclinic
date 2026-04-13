import 'package:equatable/equatable.dart';

class FreeDoctorEntity extends Equatable {
  const FreeDoctorEntity({
    required this.title,
    required this.descriptionPoints,
    required this.fikrfreeAndroidPackage,
    required this.fikrfreeIosAppStoreUrl,
    required this.fikrfreeWebUrl,
  });

  final String title;
  final List<String> descriptionPoints;
  final String fikrfreeAndroidPackage;
  final String fikrfreeIosAppStoreUrl;
  final String fikrfreeWebUrl;

  @override
  List<Object?> get props => [
        title,
        descriptionPoints,
        fikrfreeAndroidPackage,
        fikrfreeIosAppStoreUrl,
        fikrfreeWebUrl,
      ];
}
