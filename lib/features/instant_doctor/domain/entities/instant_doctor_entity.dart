import 'package:equatable/equatable.dart';

import 'instant_doctor_provider_entity.dart';

class InstantDoctorEntity extends Equatable {
  const InstantDoctorEntity({required this.providers});

  final List<InstantDoctorProviderEntity> providers;

  @override
  List<Object?> get props => [providers];
}
