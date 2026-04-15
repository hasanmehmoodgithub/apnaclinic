import 'package:equatable/equatable.dart';

class OurServiceEntity extends Equatable {
  const OurServiceEntity({
    required this.title,
    required this.subtitle,
    required this.offerUpto,
    required this.thumb,
    required this.route,
    required this.visibility,
  });

  final String title;
  final String subtitle;
  final String offerUpto;
  final String thumb;
  final String route;
  final bool visibility;

  @override
  List<Object?> get props => [
    title,
    subtitle,
    offerUpto,
    thumb,
    route,
    visibility,
  ];
}

