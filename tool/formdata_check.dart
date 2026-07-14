import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

Future<void> main() async {
  final formData = FormData.fromMap({
    'doctorId': '14051',
    'tenantId': '12',
    'consultationFee': '1000',
    'patientId': '1',
    'patientRelation': 'self',
    'slotDate': '2026-07-14',
    'slotStartTime': '05:00 PM',
    'slotEndTime': '05:10 PM',
    'paymentMethod': 'JAZZCASH',
    'msisdn': '923012123411',
    'issue': 'Persistent headache',
  });
  formData.files.add(MapEntry(
    'attachments',
    MultipartFile.fromBytes(
      utf8.encode('fake-png'),
      filename: 'test.png',
      contentType: MediaType('image', 'png'),
    ),
  ));
  print('boundary=${formData.boundary}');
  print('content-type=multipart/form-data; boundary=${formData.boundary}');
  final bytes = await formData.readAsBytes();
  print('--- body ---');
  print(utf8.decode(bytes));
  print('length=${bytes.length}');
}
