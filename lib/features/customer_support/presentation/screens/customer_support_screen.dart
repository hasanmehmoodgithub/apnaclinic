import 'package:apnaclinic/core/di/dependency_injection.dart';
import 'package:apnaclinic/core/enums/state_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/customer_support_cubit.dart';
import '../cubit/customer_support_state.dart';
import '../widgets/support_body_panel.dart';
import '../widgets/support_top_header.dart';

/// Customer Support: cyan header + shield/phone hero, overlapping help body.
class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({
    super.key,
    this.showBackButton = true,
    this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  static const double _topBannerFraction = 0.39;
  static const double _cardOverlap = 32;

  @override
  Widget build(BuildContext context) {
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;

    return BlocProvider(
      create: (_) => sl<CustomerSupportCubit>(),
      child: BlocConsumer<CustomerSupportCubit, CustomerSupportState>(
        listener: (context, state) {
          if (state.loadingStateStatus == StateStatus.error &&
              state.errorMessage != null &&
              state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: bannerHeight,
                  child: SupportTopHeader(
                    showBackButton: showBackButton,
                    onBack: onBack,
                  ),
                ),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: -_cardOverlap,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SupportBodyPanel(state: state),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
