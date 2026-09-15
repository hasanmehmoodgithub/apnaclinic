import 'package:equatable/equatable.dart';

/// Patient collected on the booking screen (Self by default until edited).
class LabTestPatientDetails extends Equatable {
  const LabTestPatientDetails({
    required this.name,
    required this.age,
    required this.gender,
  });

  final String name;
  final String age;

  /// `male` or `female`.
  final String gender;

  @override
  List<Object?> get props => [name, age, gender];
}
