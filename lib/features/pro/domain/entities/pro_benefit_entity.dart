import 'package:equatable/equatable.dart';

class ProBenefitEntity extends Equatable {
  const ProBenefitEntity({
    required this.key,
    required this.title,
    required this.basicValue,
    required this.proValue,
    required this.highlightPro,
  });

  final String key;
  final String title;
  final String basicValue;
  final String proValue;
  final bool highlightPro;

  @override
  List<Object?> get props => [key, title, basicValue, proValue, highlightPro];
}
