import 'package:equatable/equatable.dart';

/// City served by a pharmacy partner (from pharmacy cities API).
class PharmacyCityEntity extends Equatable {
  const PharmacyCityEntity({
    required this.id,
    required this.name,
    this.slug = '',
    this.partner = '',
  });

  final int id;
  final String name;
  final String slug;

  /// Analytics only — do not branch UI on this.
  final String partner;

  bool get isValid => id > 0 && name.trim().isNotEmpty;

  @override
  List<Object?> get props => [id, name, slug, partner];
}
