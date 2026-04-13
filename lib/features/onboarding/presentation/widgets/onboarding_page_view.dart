import 'package:flutter/material.dart';

import 'onboarding_page_data.dart';

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    super.key,
    required this.controller,
    required this.pages,
    required this.scale,
    required this.onPageChanged,
  });

  final PageController controller;
  final List<OnboardingPageData> pages;
  final double scale;
  final ValueChanged<int> onPageChanged;

  static const Color _mint = Color(0xFF0FAE9D);
  static const Color _subtitle = Color(0xFF6E6E6E);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: pages.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) => Column(
        children: [
          SizedBox(
            height: 395 * scale,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 10 * scale,
                  child: Container(
                    width: 360 * scale,
                    height: 324 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _mint, width: 30 * scale),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    pages[index].imageAsset,
                    fit: BoxFit.contain,
                    height: 395 * scale,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 64 * scale),
          Text(
            pages[index].title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36 * scale,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 22 * scale),
          Text(
            pages[index].subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18 * scale,
              fontWeight: FontWeight.w400,
              color: _subtitle,
            ),
          ),
        ],
      ),
    );
  }
}
