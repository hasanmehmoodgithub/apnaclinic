import 'dart:convert';
import 'dart:io';

import 'package:danger_core/danger_core.dart';

const int maxWidgetFileLines = 300;

Future<void> main() async {
  final createdFiles = danger.git.createdFiles;
  final modifiedFiles = danger.git.modifiedFiles;
  final changedFiles = <String>{...createdFiles, ...modifiedFiles}.toList();
  final changedDartFiles = changedFiles.where((file) => file.endsWith('.dart')).toList();

  _checkAnalysisReport();
  _checkNoSetState(changedDartFiles);
  _checkWidgetFileLineLimit(changedDartFiles);
  _checkTestsForNewLibFiles(createdFiles);

  message('Danger checks completed for this merge request.');
}

void _checkAnalysisReport() {
  const reportPath = 'analysis_report.json';
  final reportFile = File(reportPath);
  if (!reportFile.existsSync()) {
    warn('`$reportPath` was not found. Ensure the analyze CI job publishes it as an artifact.');
    return;
  }

  final lines = reportFile.readAsLinesSync();
  final errorMessages = <String>[];
  final warningMessages = <String>[];

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) {
      continue;
    }

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is! Map<String, dynamic>) {
        continue;
      }
      if (decoded['event'] != 'analysis.errors') {
        continue;
      }

      final params = decoded['params'];
      if (params is! Map<String, dynamic>) {
        continue;
      }
      final errors = params['errors'];
      if (errors is! List) {
        continue;
      }

      for (final item in errors) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final severity = (item['severity'] ?? '').toString().toUpperCase();
        final messageText = (item['message'] ?? '').toString();
        final location = item['location'];

        String locationText = '';
        if (location is Map<String, dynamic>) {
          final file = (location['file'] ?? '').toString();
          final lineNumber = location['startLine'];
          if (file.isNotEmpty && lineNumber is int) {
            locationText = '$file:$lineNumber';
          } else if (file.isNotEmpty) {
            locationText = file;
          }
        }

        final formatted = locationText.isEmpty ? messageText : '$locationText - $messageText';
        if (severity == 'ERROR') {
          errorMessages.add(formatted);
        } else {
          warningMessages.add(formatted);
        }
      }
    } catch (_) {
      // Ignore malformed lines to avoid breaking MR checks.
    }
  }

  if (errorMessages.isNotEmpty) {
    final preview = errorMessages.take(30).map((item) => '- $item').join('\n');
    fail('Analyzer errors found (${errorMessages.length}):\n$preview');
  } else {
    message('No analyzer errors found in `analysis_report.json`.');
  }

  if (warningMessages.isNotEmpty) {
    final preview = warningMessages.take(30).map((item) => '- $item').join('\n');
    warn('Analyzer warnings/info found (${warningMessages.length}):\n$preview');
  }
}

void _checkNoSetState(List<String> changedDartFiles) {
  final violations = <String>[];
  for (final filePath in changedDartFiles) {
    final file = File(filePath);
    if (!file.existsSync()) {
      continue;
    }
    final content = file.readAsStringSync();
    if (content.contains('setState(')) {
      violations.add(filePath);
    }
  }

  if (violations.isNotEmpty) {
    final list = violations.map((file) => '- $file').join('\n');
    fail('Found `setState(` in changed Dart files:\n$list\nUse Cubit/Bloc state updates instead.');
  } else {
    message('No `setState(` usage found in changed Dart files.');
  }
}

void _checkWidgetFileLineLimit(List<String> changedDartFiles) {
  final widgetFiles = changedDartFiles.where((file) => file.contains('/presentation/widgets/')).toList();
  final oversized = <String>[];

  for (final filePath in widgetFiles) {
    final file = File(filePath);
    if (!file.existsSync()) {
      continue;
    }
    final lineCount = file.readAsLinesSync().length;
    if (lineCount > maxWidgetFileLines) {
      oversized.add('$filePath ($lineCount lines)');
    }
  }

  if (oversized.isNotEmpty) {
    fail(
      'Widget file line limit exceeded (max $maxWidgetFileLines lines):\n'
      '${oversized.map((item) => '- $item').join('\n')}',
    );
  } else {
    message('All changed widget files are within $maxWidgetFileLines lines.');
  }
}

void _checkTestsForNewLibFiles(List<String> createdFiles) {
  final newLibFiles = createdFiles
      .where((file) => file.startsWith('lib/') && file.endsWith('.dart'))
      .where((file) => !file.endsWith('.g.dart') && !file.endsWith('.freezed.dart'))
      .toList();

  final missingTests = <String>[];
  for (final libFile in newLibFiles) {
    final relative = libFile.substring(4, libFile.length - 5);
    final testPath = 'test/${relative}_test.dart';
    if (!File(testPath).existsSync()) {
      missingTests.add('$libFile -> expected $testPath');
    }
  }

  if (missingTests.isNotEmpty) {
    fail(
      'New `lib/` files must include tests:\n'
      '${missingTests.map((item) => '- $item').join('\n')}',
    );
  } else if (newLibFiles.isNotEmpty) {
    message('Test presence check passed for new `lib/` files.');
  }
}
