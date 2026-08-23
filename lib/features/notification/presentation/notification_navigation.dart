import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/auth_guard.dart';
import '../../bookings/data/models/surgery_details_item.dart';
import '../../bookings/presentation/doctor_consultation_booking_details_args.dart';
import '../../bookings/presentation/widgets/alert_dialog_card.dart';
import '../../lab_test/presentation/lab_test_route_args.dart';
import '../domain/entities/notification_entity.dart';

typedef _PushNamed = void Function(String name, {Object? extra});

/// Opens the booking / order screen for a notification's `serviceType`.
///
/// Prefers `deepLink.data.unified_order_id`; falls back to `entity.id` /
/// `entity_id` when the unified id is missing. Pharmacy uses
/// `deepLink.entity.publicId`.
///
/// Returns `true` when navigation was started; `false` when the notification
/// cannot be routed (missing booking id, unsupported service type, etc.).
bool openNotificationDeepLink(
  BuildContext context,
  NotificationEntity item,
) {
  return _openBookingScreen(
    serviceType: item.serviceType,
    bookingId: _bookingId(item),
    pharmacyOrderId: item.entityPublicId.trim().isNotEmpty
        ? item.entityPublicId.trim()
        : _bookingId(item),
    pushNamed: (name, {extra}) {
      context.pushNamed(name, extra: extra);
    },
  );
}

/// Opens the screen for an FCM / local-notification tap.
///
/// Prefers the same booking-details flow as the inbox (`serviceType` + ids).
/// Falls back to `route` / `deepLink` / `screen` as a named GoRouter path.
bool openPushNotificationLink({
  required Map<String, dynamic> data,
  String? route,
}) {
  if (!AuthGuard.isLoggedIn()) {
    developer.log(
      'Push tap skipped: user is not logged in',
      name: 'NotificationNavigation',
    );
    return false;
  }

  final parsed = _parsePushTarget(data, route);
  final openedBooking = _openBookingScreen(
    serviceType: parsed.serviceType,
    bookingId: parsed.bookingId,
    pharmacyOrderId: parsed.pharmacyOrderId,
    pushNamed: (name, {extra}) {
      AppRouter.router.pushNamed(name, extra: extra);
    },
  );
  if (openedBooking) return true;

  return _openNamedRoute(parsed.route);
}

String _bookingId(NotificationEntity item) {
  final unified = item.unifiedOrderId.trim();
  if (unified.isNotEmpty) return unified;
  return item.entityId.trim();
}

bool _openBookingScreen({
  required String serviceType,
  required String bookingId,
  required String pharmacyOrderId,
  required _PushNamed pushNamed,
}) {
  final service = serviceType.trim().toUpperCase();
  if (service.isEmpty) return false;

  try {
    switch (service) {
      case 'CONSULTATION':
      case 'CONSULTANCY':
        if (bookingId.isEmpty) return false;
        pushNamed(
          AppRoutes.doctorConsultationBookingDetails,
          extra: DoctorConsultationBookingDetailsArgs(bookingId: bookingId),
        );
        return true;
      case 'SURGERY':
        if (bookingId.isEmpty) return false;
        pushNamed(
          AppRoutes.surgeryBookingDetails,
          extra: SurgeryBookingDetailsArgs(
            leadId: bookingId,
            item: _placeholderSurgeryItem(bookingId),
            initialStatus: SurgeryBookingStatus.inReview,
          ),
        );
        return true;
      case 'LAB':
      case 'LABTEST':
      case 'LAB-TESTING':
      case 'LAB_TESTING':
        if (bookingId.isEmpty) return false;
        pushNamed(
          AppRoutes.labTestViewDetails,
          extra: LabTestViewDetailsArgs(orderId: bookingId),
        );
        return true;
      case 'PHARMACY':
        final orderId = pharmacyOrderId.isNotEmpty
            ? pharmacyOrderId
            : bookingId;
        if (orderId.isEmpty) return false;
        pushNamed(
          AppRoutes.pharmacyBookingDetails,
          extra: {'orderId': orderId},
        );
        return true;
      default:
        return false;
    }
  } catch (e, stackTrace) {
    developer.log(
      'Booking deep link failed: $e',
      name: 'NotificationNavigation',
      error: e,
      stackTrace: stackTrace,
    );
    return false;
  }
}

final _routesThatNeedExtra = {
  AppRoutes.doctorConsultationBookingDetails,
  AppRoutes.surgeryBookingDetails,
  AppRoutes.labTestViewDetails,
  AppRoutes.pharmacyBookingDetails,
};

bool _openNamedRoute(String? route) {
  final name = _namedRouteFromKey(route);
  if (name == null || name.isEmpty) return false;
  if (_routesThatNeedExtra.contains(name)) return false;

  try {
    if (name == AppRoutes.home) {
      AppRouter.router.go(AppRoutes.path(AppRoutes.home));
      return true;
    }
    AppRouter.router.pushNamed(name);
    return true;
  } catch (e, stackTrace) {
    developer.log(
      'Named route deep link failed ($name): $e',
      name: 'NotificationNavigation',
      error: e,
      stackTrace: stackTrace,
    );
    return false;
  }
}

String? _namedRouteFromKey(String? raw) {
  if (raw == null) return null;
  final key = raw.trim().replaceFirst(RegExp(r'^/'), '').toLowerCase();
  if (key.isEmpty || key.startsWith('{')) return null;

  return switch (key) {
    'consultation' => AppRoutes.consultation,
    'pharmacy' || 'pharmacymain' => AppRoutes.pharmacyMain,
    'lab' ||
    'labtest' ||
    'lab-testing' ||
    'lab_testing' => AppRoutes.labTest,
    'surgery' => AppRoutes.surgery,
    'notifications' || 'notification' => AppRoutes.notifications,
    'home' => AppRoutes.home,
    _ => raw.trim().replaceFirst(RegExp(r'^/'), ''),
  };
}

class _PushTarget {
  const _PushTarget({
    required this.serviceType,
    required this.bookingId,
    required this.pharmacyOrderId,
    required this.route,
  });

  final String serviceType;
  final String bookingId;
  final String pharmacyOrderId;
  final String? route;
}

_PushTarget _parsePushTarget(Map<String, dynamic> data, String? route) {
  final flat = _expandPushData(data);
  final parsedRoute = _read(flat, const ['route', 'screen']);
  var resolvedRoute = (route != null && route.trim().isNotEmpty)
      ? route.trim()
      : (parsedRoute.isEmpty ? null : parsedRoute);
  if (resolvedRoute != null && resolvedRoute.startsWith('{')) {
    resolvedRoute = null;
  }

  var serviceType = _read(flat, const ['serviceType', 'service_type']);
  if (serviceType.isEmpty) {
    serviceType = _serviceTypeFromRoute(resolvedRoute);
  }

  final bookingId = _read(flat, const [
    'unified_order_id',
    'unifiedOrderId',
    'booking_id',
    'bookingId',
    'entity_id',
    'entityId',
    'orderId',
    'order_id',
    'leadId',
    'lead_id',
  ]);
  final pharmacyOrderId = _readEntityPublicId(flat);

  return _PushTarget(
    serviceType: serviceType,
    bookingId: bookingId,
    pharmacyOrderId: pharmacyOrderId,
    route: resolvedRoute,
  );
}

String _serviceTypeFromRoute(String? route) {
  final key = (route ?? '').toLowerCase();
  if (key.contains('consultation') || key.contains('consultancy')) {
    return 'CONSULTATION';
  }
  if (key.contains('pharmacy')) return 'PHARMACY';
  if (key.contains('lab')) return 'LAB';
  if (key.contains('surgery')) return 'SURGERY';
  return '';
}

Map<String, dynamic> _expandPushData(Map<String, dynamic> data) {
  final out = <String, dynamic>{};
  _absorb(out, data);
  _flattenDottedKeys(out);

  final deepLink = _asMap(out['deepLink'] ?? out['deep_link']);
  if (deepLink == null) return out;

  _absorb(out, deepLink);
  final nested = _asMap(deepLink['data']);
  if (nested != null) _absorb(out, nested);

  final entity = _asMap(deepLink['entity']);
  if (entity != null) {
    final id = entity['id'];
    if (id != null && _read(out, const ['entity_id', 'entityId']).isEmpty) {
      out['entity_id'] = id;
    }
    final publicId = entity['publicId'] ?? entity['public_id'];
    if (publicId != null && publicId.toString().trim().isNotEmpty) {
      out['entityPublicId'] = publicId;
    }
  }
  return out;
}

void _absorb(Map<String, dynamic> into, Map<dynamic, dynamic> source) {
  source.forEach((key, value) {
    final decoded = _asMap(value);
    into[key.toString()] = decoded ?? value;
  });
}

void _flattenDottedKeys(Map<String, dynamic> into) {
  for (final key in List<String>.from(into.keys)) {
    if (!key.contains('.')) continue;
    final normalized = key.toLowerCase().replaceAll('_', '');
    if (normalized.endsWith('entity.publicid')) {
      if (_read(into, const ['entityPublicId']).isEmpty) {
        into['entityPublicId'] = into[key];
      }
      continue;
    }
    final last = key.split('.').last;
    if (last.isEmpty) continue;
    if (_read(into, [last]).isEmpty) {
      into[last] = into[key];
    }
  }
}

/// Same source as the inbox: `deepLink.entity.publicId` only.
/// Never uses the notification's own top-level `publicId`.
String _readEntityPublicId(Map<String, dynamic> flat) {
  final dedicated = _read(flat, const ['entityPublicId', 'entity_public_id']);
  if (dedicated.isNotEmpty) return dedicated;

  final entity = _asMap(flat['entity']);
  final fromEntity = _read(entity ?? const {}, const ['publicId', 'public_id']);
  if (fromEntity.isNotEmpty) return fromEntity;

  final deepLink = _asMap(flat['deepLink'] ?? flat['deep_link']);
  final nestedEntity = _asMap(deepLink?['entity']);
  return _read(nestedEntity ?? const {}, const ['publicId', 'public_id']);
}

Map<String, dynamic>? _asMap(dynamic raw) {
  if (raw is Map) return Map<String, dynamic>.from(raw);
  if (raw is String) {
    var text = raw.trim();
    if (text.length >= 2 && text.startsWith('"') && text.endsWith('"')) {
      try {
        final unquoted = jsonDecode(text);
        if (unquoted is String) text = unquoted.trim();
      } catch (_) {}
    }
    if (text.startsWith('{')) {
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
  }
  return null;
}

String _read(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value == null || value is Map || value is List) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
  }
  return '';
}

/// Shows notification content when deep link routing is unavailable.
Future<void> showNotificationUnavailableDialog(
  BuildContext context,
  NotificationEntity item,
) {
  final l10n = AppLocalizations.of(context)!;
  final title = item.title.trim().isNotEmpty
      ? item.title.trim()
      : l10n.notificationsDeepLinkUnavailableTitle;
  final message = item.message.trim().isNotEmpty
      ? item.message.trim()
      : l10n.notificationsDeepLinkUnavailableMessage;

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) => AlertDialogCard(
      kind: AlertKind.error,
      title: title,
      message: message,
    ),
  );
}

SurgeryDetailsItem _placeholderSurgeryItem(String leadId) {
  return SurgeryDetailsItem(
    leadId: leadId,
    procedure: '',
    procedureSubtitle: '',
    hospital: '',
    doctor: '',
    specialty: '',
    qualification: '',
    status: '',
    dateCreated: '',
    patientName: '',
    age: 0,
    gender: '',
    contactNumber: '',
    emergencyContact: '',
    fee: 0,
    discountPercent: 0,
    discountAmount: 0,
    total: 0,
    paymentAllowed: false,
    appointmentDay: '',
    appointmentMonth: '',
    appointmentWeekday: '',
    appointmentTime: '',
    appointmentSubtitle: '',
    appointmentDateFull: '',
    partnerLogoUrl: '',
  );
}
