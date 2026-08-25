import 'package:equatable/equatable.dart';

class AiScreeningEntity extends Equatable {
  const AiScreeningEntity({
    required this.link,
    required this.show,
    required this.permissions,
  });

  final String link;
  final bool show;
  final List<String> permissions;

  bool get hasValidLink => link.trim().isNotEmpty;

  bool get shouldShow => show && hasValidLink;

  bool get needsCamera =>
      permissions.any((value) => value.toLowerCase() == 'camera');

  bool get needsMicrophone => permissions.any((value) {
    final lower = value.toLowerCase();
    return lower == 'microphone' || lower == 'mic';
  });

  @override
  List<Object?> get props => [link, show, permissions];
}
