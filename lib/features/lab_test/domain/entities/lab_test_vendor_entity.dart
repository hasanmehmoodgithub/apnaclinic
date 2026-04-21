import 'package:equatable/equatable.dart';

class LabTestVendorEntity extends Equatable {
  const LabTestVendorEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.markUrl,
  });

  final String id;
  final String name;
  final String logoUrl;
  final String? markUrl;

  @override
  List<Object?> get props => [id, name, logoUrl, markUrl];
}
