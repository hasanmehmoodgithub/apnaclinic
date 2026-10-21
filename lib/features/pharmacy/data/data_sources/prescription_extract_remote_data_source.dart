import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../domain/entities/prescription_extract_entity.dart';
import '../../domain/prescription_scan_error_codes.dart';
import '../models/prescription_extract_model.dart';
import '../prescription_extract_config.dart';

class PrescriptionExtractException implements Exception {
  const PrescriptionExtractException(this.code, {this.detail});

  final String code;
  final String? detail;
}

class PrescriptionExtractRemoteDataSource {
  PrescriptionExtractRemoteDataSource({Dio? dio}) : _dio = dio ?? _createDio();

  final Dio _dio;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: PrescriptionExtractConfig.baseUrl,
        preserveHeaderCase: true,
        connectTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 90),
        receiveTimeout: const Duration(seconds: 90),
        headers: {'X-API-Key': PrescriptionExtractConfig.apiKey},
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-API-Key'] = PrescriptionExtractConfig.apiKey;
          handler.next(options);
        },
      ),
    );
    return dio;
  }

  Future<PrescriptionExtractEntity> extract({required String filePath}) async {
    if (PrescriptionExtractConfig.apiKey.trim().isEmpty ||
        PrescriptionExtractConfig.baseUrl.trim().isEmpty) {
      throw const PrescriptionExtractException(
        PrescriptionScanErrorCodes.notConfigured,
      );
    }

    try {
      final fileName = _fileName(filePath);
      final formData = FormData.fromMap(<String, dynamic>{
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: _mediaType(fileName),
        ),
      });

      final response = await _dio.post<dynamic>(
        PrescriptionExtractConfig.extractPath,
        data: formData,
        options: Options(
          preserveHeaderCase: true,
          headers: {'X-API-Key': PrescriptionExtractConfig.apiKey},
        ),
      );

      final data = response.data;
      final json = data is Map<String, dynamic>
          ? data
          : data is Map
          ? Map<String, dynamic>.from(data)
          : null;
      if (json == null) {
        throw const PrescriptionExtractException(
          PrescriptionScanErrorCodes.extractFailed,
        );
      }
      return PrescriptionExtractModel.fromJson(json);
    } on PrescriptionExtractException {
      rethrow;
    } on DioException catch (error) {
      final detail = _serverDetail(error.response?.data);
      throw PrescriptionExtractException(
        PrescriptionScanErrorCodes.extractFailed,
        detail: detail,
      );
    } catch (_) {
      throw const PrescriptionExtractException(
        PrescriptionScanErrorCodes.extractFailed,
      );
    }
  }

  static String? _serverDetail(Object? data) {
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String && detail.trim().isNotEmpty) return detail.trim();
    }
    if (data is String) {
      final text = data.trim();
      if (text.isNotEmpty && !text.startsWith('<')) return text;
    }
    return null;
  }

  static String _fileName(String path) {
    final normalized = path.replaceAll('\\', '/');
    final name = normalized.split('/').last.trim();
    if (name.isEmpty) return 'prescription.jpg';
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'webp') {
      return name;
    }
    return 'prescription.jpg';
  }

  static MediaType _mediaType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    if (ext == 'png') return MediaType('image', 'png');
    if (ext == 'webp') return MediaType('image', 'webp');
    return MediaType('image', 'jpeg');
  }
}
