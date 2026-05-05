import 'package:flutter/material.dart';

/// Shown when search/filter yields no lab tests.
class LabTestCatalogEmptyWidget extends StatelessWidget {
  const LabTestCatalogEmptyWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
