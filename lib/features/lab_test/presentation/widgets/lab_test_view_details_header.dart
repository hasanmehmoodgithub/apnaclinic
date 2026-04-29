import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class LabTestViewDetailsHeader extends StatelessWidget {
  const LabTestViewDetailsHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 18),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => context.pop(),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF061E40),
                  size: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
