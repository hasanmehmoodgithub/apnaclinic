import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../generated/assets.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({super.key, required this.child, this.onBackTap});

  final Widget child;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth.clamp(0, 430).toDouble();
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: contentWidth,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 104.61,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF87DDD3), Colors.white],
                          stops: [0, 0.2813],
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(40),
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: -250,
                            height: 355,
                            child: SvgPicture.asset(
                              'assets/svg/frame_1171275326.svg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 10.15,
                            left: 23.33,
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: onBackTap,
                                  child: const Icon(
                                    Icons.arrow_back_rounded,
                                    color: Color(0xFF061E40),
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: SvgPicture.asset(
                              Assets.svgBrandApnaClinic,
                              width: 258.63,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF4F5F7),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(42),
                          ),
                        ),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
