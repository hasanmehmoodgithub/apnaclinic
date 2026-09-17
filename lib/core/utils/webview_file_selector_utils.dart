import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

/// Handles Android WebView `<input type="file">` via the system picker.
///
/// Returns `file://` URIs WebView can read. Uses [ImagePicker] for image-only
/// / camera capture requests and [FilePicker] otherwise (no broad storage
/// permission — SAF / Photo Picker).
Future<List<String>> handleAndroidWebViewFileSelection(
  FileSelectorParams params,
) async {
  try {
    if (params.mode == FileSelectorMode.save) return const [];

    final allowMultiple = params.mode == FileSelectorMode.openMultiple;
    final accept = params.acceptTypes
        .map((type) => type.trim().toLowerCase())
        .where((type) => type.isNotEmpty)
        .toList(growable: false);

    if (params.isCaptureEnabled) {
      return _pickCapture(accept);
    }

    if (_isImageOnlyAccept(accept)) {
      return _pickImages(allowMultiple: allowMultiple);
    }

    return _pickFiles(
      allowMultiple: allowMultiple,
      acceptTypes: accept,
    );
  } catch (_) {
    return const [];
  }
}

Future<List<String>> _pickCapture(List<String> accept) async {
  final picker = ImagePicker();
  if (accept.any(_isVideoAccept) && !accept.any(_isImageAccept)) {
    final video = await picker.pickVideo(source: ImageSource.camera);
    if (video == null) return const [];
    return [Uri.file(video.path).toString()];
  }

  final image = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 85,
  );
  if (image == null) return const [];
  return [Uri.file(image.path).toString()];
}

Future<List<String>> _pickImages({required bool allowMultiple}) async {
  final picker = ImagePicker();
  if (allowMultiple) {
    final images = await picker.pickMultiImage(imageQuality: 85);
    return images
        .map((file) => Uri.file(file.path).toString())
        .toList(growable: false);
  }

  final image = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 85,
  );
  if (image == null) return const [];
  return [Uri.file(image.path).toString()];
}

Future<List<String>> _pickFiles({
  required bool allowMultiple,
  required List<String> acceptTypes,
}) async {
  final extensions = _extensionsFromAcceptTypes(acceptTypes);
  final result = await FilePicker.pickFiles(
    allowMultiple: allowMultiple,
    type: extensions.isEmpty ? FileType.any : FileType.custom,
    allowedExtensions: extensions.isEmpty ? null : extensions,
  );
  if (result == null || result.files.isEmpty) return const [];

  return result.files
      .map((file) => file.path?.trim() ?? '')
      .where((path) => path.isNotEmpty)
      .map((path) => Uri.file(path).toString())
      .toList(growable: false);
}

bool _isImageOnlyAccept(List<String> accept) {
  if (accept.isEmpty) return false;
  return accept.every(_isImageAccept);
}

bool _isImageAccept(String type) {
  return type == 'image/*' ||
      type.startsWith('image/') ||
      type == '.png' ||
      type == '.jpg' ||
      type == '.jpeg' ||
      type == '.webp' ||
      type == '.gif' ||
      type == '.heic';
}

bool _isVideoAccept(String type) {
  return type == 'video/*' || type.startsWith('video/');
}

List<String> _extensionsFromAcceptTypes(List<String> acceptTypes) {
  final extensions = <String>{};
  for (final raw in acceptTypes) {
    final type = raw.trim().toLowerCase();
    if (type.isEmpty || type == '*/*') continue;
    if (type.startsWith('.')) {
      extensions.add(type.substring(1));
      continue;
    }
    if (type == 'image/*') {
      extensions.addAll(const ['png', 'jpg', 'jpeg', 'webp', 'gif', 'heic']);
    } else if (type == 'image/png') {
      extensions.add('png');
    } else if (type == 'image/jpeg' || type == 'image/jpg') {
      extensions.addAll(const ['jpg', 'jpeg']);
    } else if (type == 'image/webp') {
      extensions.add('webp');
    } else if (type == 'application/pdf') {
      extensions.add('pdf');
    } else if (type == 'video/*') {
      extensions.addAll(const ['mp4', 'mov', '3gp', 'mkv']);
    } else if (type.contains('/')) {
      final subtype = type.split('/').last;
      if (subtype.isNotEmpty && subtype != '*') {
        extensions.add(subtype);
      }
    }
  }
  return extensions.toList(growable: false);
}
