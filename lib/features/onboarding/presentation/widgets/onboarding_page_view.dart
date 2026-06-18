import 'package:flutter/material.dart';

import 'onboarding_page_data.dart';
import 'onboarding_scale.dart';

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
      itemBuilder: (context, index) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxH = constraints.maxHeight;
            final horizontalPad = onboardingScaled(24, scale);
            final availableWidth = (constraints.maxWidth - (horizontalPad * 2))
                .clamp(120.0, constraints.maxWidth);
            final imageHeight = (maxH * 0.52).clamp(
              onboardingScaled(200, scale),
              onboardingScaled(395, scale),
            );
            final titleGap = onboardingScaled(22, scale).clamp(12.0, 22.0);
            final imageToTextGap =
                onboardingScaled(32, scale).clamp(16.0, 64.0);
            final titleSize = onboardingScaled(36, scale).clamp(22.0, 36.0);
            final subtitleSize = onboardingScaled(18, scale).clamp(14.0, 18.0);
            final ringUpperBound = (availableWidth * 0.92).clamp(150.0, 360.0);
            final ringSize =
                onboardingScaled(360, scale).clamp(150.0, ringUpperBound);
            final ringBorder = onboardingScaled(30, scale).clamp(16.0, 30.0);

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: horizontalPad),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: maxH),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [

                          Positioned.fill(
                            child: Image.asset(
                              pages[index].imageAsset,
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: imageToTextGap),
                    Text(
                      pages[index].title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: titleGap),
                    Text(
                      pages[index].subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w400,
                        color: _subtitle,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
