import 'package:flutter/material.dart';
import 'comprehensive_examples_screen.dart';

/// Main examples screen - redirects to comprehensive screen
class ExamplesMainScreen extends StatelessWidget {
  const ExamplesMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComprehensiveExamplesScreen();
  }
}
