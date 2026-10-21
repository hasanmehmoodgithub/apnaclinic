import 'package:equatable/equatable.dart';

class ApnaClinicAiHomeTileEntity extends Equatable {
  const ApnaClinicAiHomeTileEntity({
    required this.id,
    required this.title,
    required this.send,
    this.subtitle,
  });

  final String id;
  final String title;
  final String send;
  final String? subtitle;

  @override
  List<Object?> get props => [id, title, send, subtitle];
}
