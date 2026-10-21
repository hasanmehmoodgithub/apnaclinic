import '../../domain/apna_clinic_ai_failure_codes.dart';
import '../models/apna_clinic_ai_turn_model.dart';

/// Turns assistant prose and SDK blocks into doctor, slot, and payment cards.
class ApnaClinicAiTurnParser {
  ApnaClinicAiTurnParser._();

  static final _doctorId = RegExp(r'doctorId\s*\d+', caseSensitive: false);
  /// Matches booking chip sends, e.g.
  /// `Book the 03:00 PM – 03:10 PM slot on 2026-10-21 with doctorId 6538`
  static final _slotSend = RegExp(
    r'(\d{1,2}:\d{2}\s*[AP]M).*?\bon\s+(\d{4}-\d{2}-\d{2})',
    caseSensitive: false,
  );
  static final _isoDate = RegExp(r'(\d{4}-\d{2}-\d{2})');
  static final _upstream = RegExp(
    r'invalid response was received from the upstream|upstream server|502|504',
    caseSensitive: false,
  );
  static final _bookingJson = RegExp(
    r'^\s*\{[\s\S]*"message"\s*:|request_id',
    caseSensitive: false,
  );

  static ApnaClinicAiTurnModel parse(Map<String, dynamic> json) {
    var reply = (json['reply'] ?? json['text'] ?? '').toString();
    final status = json['status']?.toString();
    String? failureCode;
    if (status == 'failed' || _upstream.hasMatch(reply) || _bookingJson.hasMatch(reply)) {
      failureCode = _upstream.hasMatch(reply)
          ? ApnaClinicAiFailureCodes.upstream
          : ApnaClinicAiFailureCodes.booking;
      reply = '';
    }

    final enriched = _enrich(reply);
    final blocks = _fromBlocks(json['blocks']);
    final actions = _quickActions(json);
    // Book-slot options include doctorId — do not treat them as doctor cards.
    final doctorish = actions
        .where(
          (a) => _doctorId.hasMatch(a.send) && _slotDate(a.send) == null,
        )
        .toList();

    final actionSlots = [
      for (final action in actions)
        if (_slotDate(action.send) != null)
          ApnaClinicAiSlotModel(
            label: action.label.trim().isEmpty ? action.send : action.label,
            send: action.send,
          ),
    ];
    final chipSlots = blocks.slotChips.isNotEmpty
        ? blocks.slotChips
        : actionSlots;
    final slotDays = chipSlots.isNotEmpty
        ? _groupSlotDays(chipSlots)
        : _groupSlotDays(enriched.slots);
    final slots = slotDays.isEmpty
        ? (chipSlots.isNotEmpty ? chipSlots : enriched.slots)
        : slotDays.expand((day) => day.slots).toList();

    final doctors = <ApnaClinicAiDoctorCardModel>[];
    // Slot calendar already covers booking — skip doctor rail for this turn.
    if (slotDays.isEmpty) {
      final blockById = <String, ApnaClinicAiDoctorCardModel>{};
      final blockByName = <String, ApnaClinicAiDoctorCardModel>{};
      for (final doctor in blocks.doctors) {
        final id = RegExp(r'doctorId\s+(\d+)', caseSensitive: false)
            .firstMatch(doctor.send)
            ?.group(1);
        if (id != null) blockById[id] = doctor;
        final key = doctor.name.trim().toLowerCase();
        if (key.isNotEmpty) blockByName[key] = doctor;
      }
      if (doctorish.isNotEmpty) {
        final byId = <String, ApnaClinicAiDoctorCardModel>{};
        for (final doctor in enriched.doctors) {
          final id = RegExp(r'doctorId\s+(\d+)', caseSensitive: false)
              .firstMatch(doctor.send)
              ?.group(1);
          if (id != null) byId[id] = doctor;
        }
        for (final action in doctorish) {
          final parsed = _parseDoctorSend(action.send, action.label);
          final rich = parsed.id != null ? byId[parsed.id] : null;
          final fromBlock = (parsed.id != null ? blockById[parsed.id] : null) ??
              blockByName[(rich?.name ?? parsed.name).trim().toLowerCase()];
          doctors.add(
            ApnaClinicAiDoctorCardModel(
              id: fromBlock?.id ?? parsed.id,
              kind: fromBlock?.kind ?? 'doctor',
              name: rich?.name ?? fromBlock?.name ?? parsed.name,
              specialty:
                  rich?.specialty ?? fromBlock?.specialty ?? parsed.specialty,
              years: rich?.years ?? fromBlock?.years ?? parsed.years,
              fee: rich?.fee ?? fromBlock?.fee ?? parsed.fee,
              rating: rich?.rating ?? fromBlock?.rating,
              imageUrl: fromBlock?.imageUrl ?? rich?.imageUrl,
              badge: fromBlock?.badge,
              description: fromBlock?.description,
              cta: fromBlock?.cta,
              send: parsed.send,
            ),
          );
        }
      } else if (blocks.doctors.isNotEmpty) {
        doctors.addAll(blocks.doctors);
      } else {
        doctors.addAll(enriched.doctors);
      }
    }

    if (slotDays.isNotEmpty) {
      reply = _compactSlotReply(reply);
    }

    var quickActions = doctorish.isEmpty ? actions : <ApnaClinicAiQuickActionModel>[];
    if (slotDays.isNotEmpty) {
      quickActions = quickActions
          .where((action) => _slotDate(action.send) == null)
          .toList();
    }

    final payments = <ApnaClinicAiPaymentModel>[
      ...blocks.payments,
      ...enriched.payments.where(
        (p) => blocks.payments.every(
          (existing) => existing.label.toLowerCase() != p.label.toLowerCase(),
        ),
      ),
    ];

    final audio = json['audio'];
    String? audioBase64;
    String? audioMediaType;
    if (audio is Map) {
      audioBase64 = audio['base64']?.toString();
      final format = audio['format']?.toString();
      audioMediaType =
          audio['media_type']?.toString() ??
          (format == 'opus' ? 'audio/ogg' : 'audio/wav');
    }

    final auth = json['auth'];
    String? resumeMessage;
    String? deepLink;
    if (auth is Map) {
      final resume = auth['resume'];
      if (resume is Map) {
        resumeMessage = resume['message']?.toString().trim();
      }
      deepLink = (auth['deep_link'] ?? auth['deepLink'])?.toString().trim();
    }
    final signInRequired = status == 'sign_in_required';
    // Internal SDK chips (e.g. __sign_in__) must not be sent as chat text.
    final visibleActions = signInRequired
        ? quickActions
              .where((a) => !a.send.trim().startsWith('__'))
              .toList()
        : quickActions;

    return ApnaClinicAiTurnModel(
      reply: reply,
      status: status,
      intent: (json['intent'] ?? json['capability'])?.toString(),
      failureCode: failureCode,
      quickActions: visibleActions,
      doctors: doctors,
      slots: slots,
      slotDays: slotDays,
      payments: payments,
      audioBase64: (audioBase64 == null || audioBase64.isEmpty) ? null : audioBase64,
      audioMediaType: audioMediaType,
      signInRequired: signInRequired,
      authResumeMessage:
          (resumeMessage == null || resumeMessage.isEmpty) ? null : resumeMessage,
      authDeepLink: (deepLink == null || deepLink.isEmpty) ? null : deepLink,
    );
  }

  static List<ApnaClinicAiSlotDayModel> _groupSlotDays(
    List<ApnaClinicAiSlotModel> slots,
  ) {
    final byDay = <String, List<ApnaClinicAiSlotModel>>{};
    for (final slot in slots) {
      final date = _slotDate(slot.send);
      if (date == null) continue;
      byDay.putIfAbsent(date, () => []).add(slot);
    }
    final dates = byDay.keys.toList()..sort();
    return [
      for (final date in dates)
        ApnaClinicAiSlotDayModel(date: date, slots: byDay[date]!),
    ];
  }

  static String? _slotDate(String send) {
    final match = _slotSend.firstMatch(send);
    if (match != null) return match.group(2);
    return _isoDate.firstMatch(send)?.group(1);
  }

  /// Drops ISO slot bullets when the interactive calendar is shown.
  static String _compactSlotReply(String reply) {
    var text = reply.replaceAll(
      RegExp(
        r'^[ \t]*[-*•]\s*\d{4}-\d{2}-\d{2}\s*[·•.].+$',
        multiLine: true,
      ),
      '',
    );
    text = text
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .replaceAll(RegExp(r'[ \t]+\n'), '\n')
        .trim();
    if (text.isEmpty) {
      return 'Pick a day and time below to book.';
    }
    return text;
  }

  static List<ApnaClinicAiQuickActionModel> _quickActions(Map<String, dynamic> json) {
    final raw = json['quick_actions'] ?? json['option_items'] ?? json['suggestions'];
    final list = raw is List ? raw : json['options'];
    if (list is! List) return const [];
    // Keep all bookable slot options (often 12+); cap only non-slot chips.
    final actions = list
        .map(_action)
        .where((a) => a.send.trim().isNotEmpty)
        .toList();
    final slotActions = actions.where((a) => _slotDate(a.send) != null).toList();
    if (slotActions.length >= actions.length * 0.6) {
      return slotActions;
    }
    return actions.take(8).toList();
  }

  static ApnaClinicAiQuickActionModel _action(dynamic raw) {
    if (raw is String) {
      final label = raw.split('—').first.trim();
      return ApnaClinicAiQuickActionModel(label: label.isEmpty ? raw : label, send: raw);
    }
    if (raw is Map) {
      final label = (raw['label'] ?? raw['send'] ?? raw['id'] ?? '').toString();
      final explicit = (raw['send'] ?? raw['message'] ?? '').toString();
      if (explicit.isNotEmpty) {
        return ApnaClinicAiQuickActionModel(label: label, send: explicit);
      }
      final id = raw['id']?.toString() ?? '';
      if (_doctorId.hasMatch(id)) {
        return ApnaClinicAiQuickActionModel(label: label, send: id);
      }
      if (RegExp(r'^\d+$').hasMatch(id) && label.isNotEmpty) {
        return ApnaClinicAiQuickActionModel(
          label: label,
          send: 'doctorId $id — show slots for $label',
        );
      }
      return ApnaClinicAiQuickActionModel(label: label, send: label);
    }
    return const ApnaClinicAiQuickActionModel(label: '', send: '');
  }

  static _ParsedDoctor _parseDoctorSend(String send, String label) {
    final id = RegExp(r'doctorId\s*(\d+)', caseSensitive: false).firstMatch(send)?.group(1);
    final rich = RegExp(
      r'doctorId\s*\d+\s*[—–-]\s*([^|]+)\|\s*([^|]+)\|\s*([^|]+)\|\s*(PKR\s*[\d,.]+)',
      caseSensitive: false,
    ).firstMatch(send);
    if (rich != null) {
      final name = rich.group(1)!.trim();
      return _ParsedDoctor(
        id: id,
        name: name,
        specialty: rich.group(2)!.trim(),
        years: rich.group(3)!.trim(),
        fee: rich.group(4)!.trim(),
        send: 'doctorId $id — show slots for $name',
      );
    }
    final name = RegExp(r'show slots for\s+(.+)$', caseSensitive: false)
            .firstMatch(send)
            ?.group(1)
            ?.trim() ??
        RegExp(r'doctorId\s*\d+\s*[—–-]\s*(.+)$', caseSensitive: false)
            .firstMatch(send)
            ?.group(1)
            ?.split('|')
            .first
            .trim() ??
        label.replaceFirst(RegExp(r'^doctorId\s*\d+\s*[—–-]?\s*', caseSensitive: false), '').trim();
    final resolved = name.isEmpty ? label : name;
    final outbound = send.toLowerCase().contains('show slots')
        ? send
        : (id == null
              ? 'show slots for $resolved'
              : 'doctorId $id — show slots for $resolved');
    return _ParsedDoctor(id: id, name: resolved, send: outbound);
  }

  static _BlockCards _fromBlocks(dynamic raw) {
    final doctors = <ApnaClinicAiDoctorCardModel>[];
    final payments = <ApnaClinicAiPaymentModel>[];
    final slotChips = <ApnaClinicAiSlotModel>[];
    if (raw is! List) return _BlockCards(doctors, payments, slotChips);
    for (final block in raw) {
      if (block is! Map) continue;
      final kind = block['kind']?.toString();
      if (kind == 'cards' && block['cards'] is List) {
        for (final card in block['cards'] as List) {
          if (card is! Map) continue;
          final meta = (card['meta'] is List)
              ? (card['meta'] as List).map((e) => e.toString()).toList()
              : const <String>[];
          final name = (card['title'] ?? '').toString();
          String? fee;
          String? rating;
          String? years;
          for (final item in meta) {
            if (fee == null && item.toLowerCase().contains('pkr')) {
              fee = item;
            } else if (years == null &&
                RegExp(r'\d+\s*yrs?', caseSensitive: false).hasMatch(item)) {
              years = item;
            }
            if (rating == null &&
                RegExp(r'★|rating', caseSensitive: false).hasMatch(item)) {
              rating = item;
            }
          }
          final amount = card['amount'];
          if (fee == null && amount != null) {
            final n = num.tryParse(amount.toString());
            if (n != null && n > 0) {
              fee = 'PKR ${n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2)}';
            }
          }
          doctors.add(
            ApnaClinicAiDoctorCardModel(
              id: card['id']?.toString(),
              kind: (card['kind'] ?? 'doctor').toString(),
              name: name,
              specialty: card['subtitle']?.toString(),
              years: years ?? (meta.isEmpty ? null : meta.first),
              fee: fee,
              rating: rating,
              imageUrl: _cardImageUrl(card),
              badge: card['badge']?.toString(),
              description: card['description']?.toString(),
              cta: card['cta']?.toString(),
              send: (card['send'] ?? card['title'] ?? '').toString(),
            ),
          );
        }
      }
      if (kind == 'chips' && block['chips'] is List) {
        final chips = <ApnaClinicAiSlotModel>[];
        for (final chip in block['chips'] as List) {
          if (chip is Map) {
            final send = (chip['send'] ?? chip['label'] ?? '').toString();
            final label = (chip['label'] ?? send).toString().trim();
            if (_slotDate(send) != null) {
              chips.add(
                ApnaClinicAiSlotModel(
                  label: label.isEmpty ? send : label,
                  send: send,
                ),
              );
            }
          } else if (chip is String && _slotDate(chip) != null) {
            chips.add(ApnaClinicAiSlotModel(label: chip, send: chip));
          }
        }
        // Prefer a full chip block of bookable slots; still accept partial.
        if (chips.isNotEmpty) {
          slotChips.addAll(chips);
        }
      }
      if (kind == 'payment_handoff' && block['handoff'] is Map) {
        final handoff = block['handoff'] as Map;
        final method = (handoff['method'] ?? handoff['name'] ?? 'Pay').toString();
        final hint = [
          handoff['amount'],
          handoff['currency'],
          handoff['description'],
        ].where((part) => part != null && part.toString().trim().isNotEmpty).join(' · ');
        payments.add(
          ApnaClinicAiPaymentModel(
            label: method,
            hint: hint.isEmpty ? null : hint,
            send: method,
          ),
        );
      }
    }
    return _BlockCards(doctors, payments, slotChips);
  }

  static _Enriched _enrich(String reply) {
    final doctors = <ApnaClinicAiDoctorCardModel>[];
    final seen = <String>{};
    final idLine = RegExp(
      r"(?:\*\*([^*]+)\*\*|((?:Assist\.?\s*Prof\.?\s*)?(?:Prof\.?\s*)?Dr\.?\s+[^\n—*·]+))\s*[—–-]?\s*([^\n]*)\n\s*doctorId\s+(\d+)",
      caseSensitive: false,
    );
    for (final match in idLine.allMatches(reply)) {
      final name = (match.group(1) ?? match.group(2) ?? '').replaceAll(RegExp(r'\s+'), ' ').trim();
      final key = name.toLowerCase();
      if (name.isEmpty || seen.contains(key)) continue;
      seen.add(key);
      final meta = (match.group(3) ?? '').trim();
      final specialty = meta.split(RegExp(r'[·|]')).first.replaceFirst(RegExp(r'^[—–-]\s*'), '').trim();
      final fee = RegExp(r'(PKR\s*[\d,.]+)', caseSensitive: false).firstMatch(meta)?.group(1);
      final yearsRaw = RegExp(r'(\d+)\s*yrs', caseSensitive: false).firstMatch(meta)?.group(1);
      final rating = RegExp(r'★\s*([\d.]+)').firstMatch(meta)?.group(1);
      final id = match.group(4)!;
      final start = (match.start - 120).clamp(0, reply.length);
      final end = (match.end + 220).clamp(0, reply.length);
      doctors.add(
        ApnaClinicAiDoctorCardModel(
          name: name,
          specialty: specialty.isEmpty || specialty.toLowerCase().startsWith('pkr') ? null : specialty,
          years: yearsRaw == null ? null : '$yearsRaw yrs',
          fee: fee,
          rating: rating,
          imageUrl: _nearbyImageUrl(reply.substring(start, end)),
          send: 'doctorId $id — show slots for $name',
        ),
      );
    }

    if (doctors.isEmpty) {
      final docRe = RegExp(
        r"((?:Assist\.?\s*Prof\.?\s*)?(?:Prof\.?\s*)?Dr\.?\s+[A-Z][A-Za-z.'\-]+(?:\s+[A-Z][A-Za-z.'\-]+){0,3})",
      );
      for (final match in docRe.allMatches(reply)) {
        final name = match.group(1)!.replaceAll(RegExp(r'\s+'), ' ').trim();
        final key = name.toLowerCase();
        if (seen.contains(key)) continue;
        seen.add(key);
        final end = (match.end + 420).clamp(0, reply.length);
        final after = reply.substring(match.start, end);
        final specialty = RegExp(r'Specialty:\s*([^\n]+)', caseSensitive: false).firstMatch(after)?.group(1)?.trim();
        final years = RegExp(r'(?:Years of Experience|Experience):\s*(\d+)', caseSensitive: false).firstMatch(after)?.group(1);
        final fee = RegExp(r'Fee:\s*(PKR\s*[\d,.]+)', caseSensitive: false).firstMatch(after)?.group(1) ??
            RegExp(r'(PKR\s*[\d,.]+)', caseSensitive: false).firstMatch(after)?.group(1);
        final rating = RegExp(r'Rating:\s*([\d.]+)', caseSensitive: false).firstMatch(after)?.group(1);
        final id = RegExp(r'doctorId\s+(\d+)', caseSensitive: false).firstMatch(after)?.group(1);
        doctors.add(
          ApnaClinicAiDoctorCardModel(
            name: name,
            specialty: specialty,
            years: years == null ? null : '$years yrs',
            fee: fee,
            rating: rating,
            imageUrl: _nearbyImageUrl(after),
            send: id == null ? 'show slots for $name' : 'doctorId $id — show slots for $name',
          ),
        );
      }
    }

    final slots = <ApnaClinicAiSlotModel>[];
    // Bullet lines from SHOW_DOCTOR_SLOTS: `- 2026-10-21 · 03:00 PM – 03:10 PM`
    final isoBullet = RegExp(
      r'(\d{4}-\d{2}-\d{2})\s*[·•]\s*(\d{1,2}:\d{2}\s*[AP]M)\s*[–—-]\s*(\d{1,2}:\d{2}\s*[AP]M)',
      caseSensitive: false,
    );
    for (final match in isoBullet.allMatches(reply)) {
      final date = match.group(1)!;
      final start = match.group(2)!.replaceAll(RegExp(r'\s+'), ' ').trim();
      final end = match.group(3)!.replaceAll(RegExp(r'\s+'), ' ').trim();
      slots.add(
        ApnaClinicAiSlotModel(
          label: start,
          send: 'Book the $start – $end slot on $date',
        ),
      );
    }
    final slotRe = RegExp(
      r'((?:Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday),?\s+(?:\d{4}-\d{2}-\d{2}|\d{1,2}\s+\w+(?:\s+\d{4})?))\s*[:—–-]\s*(\d{1,2}:\d{2}\s*[AP]M)\s*(?:to|[–—-])\s*(\d{1,2}:\d{2}\s*[AP]M)',
      caseSensitive: false,
    );
    for (final match in slotRe.allMatches(reply)) {
      final day = match.group(1)!.replaceAll(RegExp(r'\s+'), ' ').trim();
      final start = match.group(2)!.replaceAll(RegExp(r'\s+'), ' ').trim();
      final end = match.group(3)!.replaceAll(RegExp(r'\s+'), ' ').trim();
      slots.add(
        ApnaClinicAiSlotModel(
          label: '$day · $start – $end',
          send: 'book ${day.split(',').first} $start',
        ),
      );
    }

    final payments = <ApnaClinicAiPaymentModel>[];
    if (RegExp(r'CARD', caseSensitive: false).hasMatch(reply) &&
        RegExp(r'payment', caseSensitive: false).hasMatch(reply)) {
      payments.add(
        const ApnaClinicAiPaymentModel(
          label: 'Card',
          hint: 'Pay by debit / credit card',
          send: 'Card',
        ),
      );
    }
    if (RegExp(r'JAZZCASH', caseSensitive: false).hasMatch(reply)) {
      final cash = RegExp(r'JAZZCASH[^\n(]*\(([^)]+)\)', caseSensitive: false).firstMatch(reply)?.group(1);
      payments.add(
        ApnaClinicAiPaymentModel(
          label: 'JazzCash',
          hint: cash ?? 'Mobile wallet',
          send: 'JazzCash',
        ),
      );
    }
    if (RegExp(r'Yeylo|BNPL', caseSensitive: false).hasMatch(reply)) {
      payments.add(
        const ApnaClinicAiPaymentModel(
          label: 'Yeylo (BNPL)',
          hint: 'Pay in 3 monthly installments',
          send: 'BNPL',
        ),
      );
    }

    return _Enriched(doctors, slots, payments);
  }

  static String? _cardImageUrl(Map card) {
    const keys = [
      'image',
      'imageUrl',
      'image_url',
      'photo',
      'photoUrl',
      'photo_url',
      'avatar',
      'avatarUrl',
      'thumbnail',
      'picture',
      'profileImageUrl',
      'profile_image_url',
    ];
    for (final key in keys) {
      final value = card[key]?.toString().trim();
      if (value != null && _isHttpUrl(value)) return value;
    }
    final media = card['media'];
    if (media is Map) {
      for (final key in ['url', 'image', 'imageUrl', 'src']) {
        final value = media[key]?.toString().trim();
        if (value != null && _isHttpUrl(value)) return value;
      }
    }
    final images = card['images'];
    if (images is List && images.isNotEmpty) {
      final first = images.first;
      if (first is String && _isHttpUrl(first)) return first.trim();
      if (first is Map) {
        final value = (first['url'] ?? first['src'] ?? '').toString().trim();
        if (_isHttpUrl(value)) return value;
      }
    }
    return null;
  }

  static bool _isHttpUrl(String value) {
    final lower = value.toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  static String? _nearbyImageUrl(String segment) {
    final markdown = RegExp(r'!\[[^\]]*]\((https?://[^)\s]+)\)').firstMatch(segment);
    if (markdown != null) return markdown.group(1);
    final bare = RegExp(
      r'(https?://[^\s)]+\.(?:png|jpe?g|webp|gif))',
      caseSensitive: false,
    ).firstMatch(segment);
    return bare?.group(1);
  }
}

class _ParsedDoctor {
  const _ParsedDoctor({
    required this.name,
    required this.send,
    this.id,
    this.specialty,
    this.years,
    this.fee,
  });

  final String? id;
  final String name;
  final String? specialty;
  final String? years;
  final String? fee;
  final String send;
}

class _BlockCards {
  const _BlockCards(this.doctors, this.payments, this.slotChips);

  final List<ApnaClinicAiDoctorCardModel> doctors;
  final List<ApnaClinicAiPaymentModel> payments;
  final List<ApnaClinicAiSlotModel> slotChips;
}

class _Enriched {
  const _Enriched(this.doctors, this.slots, this.payments);

  final List<ApnaClinicAiDoctorCardModel> doctors;
  final List<ApnaClinicAiSlotModel> slots;
  final List<ApnaClinicAiPaymentModel> payments;
}
