import 'package:equatable/equatable.dart';

class LabTestPartnerEntity extends Equatable {
  const LabTestPartnerEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  final String id;
  final String name;
  final String logoUrl;

  @override
  List<Object?> get props => [id, name, logoUrl];
}
