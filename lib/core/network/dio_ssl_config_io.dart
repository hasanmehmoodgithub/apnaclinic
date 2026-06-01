import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

void configureDioSslForDev(Dio dio, {required bool enabled}) {
  if (!enabled) return;
  final adapter = IOHttpClientAdapter();
  adapter.createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback = (_, _, _) => true;
    return client;
  };
  dio.httpClientAdapter = adapter;
}
