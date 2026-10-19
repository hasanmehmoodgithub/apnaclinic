import '../domain/entities/pro_membership_entity.dart';

/// Last confirmed Pro membership for the current login session.
///
/// Home and the side menu share this so opening the drawer does not refetch
/// details that were already loaded.
class ProMembershipCache {
  ProMembershipSnapshot? _snapshot;

  ProMembershipSnapshot? get snapshot => _snapshot;

  bool matches({required int sessionEpoch, required int proRevision}) {
    final current = _snapshot;
    if (current == null) return false;
    return current.sessionEpoch == sessionEpoch &&
        current.proRevision == proRevision;
  }

  void save(
    ProMembershipEntity membership, {
    required int sessionEpoch,
    required int proRevision,
  }) {
    _snapshot = ProMembershipSnapshot(
      membership: membership,
      sessionEpoch: sessionEpoch,
      proRevision: proRevision,
    );
  }
}

class ProMembershipSnapshot {
  const ProMembershipSnapshot({
    required this.membership,
    required this.sessionEpoch,
    required this.proRevision,
  });

  final ProMembershipEntity membership;
  final int sessionEpoch;
  final int proRevision;
}
