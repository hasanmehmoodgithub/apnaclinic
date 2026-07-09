import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../cubit/instant_doctor_cubit.dart';
import '../cubit/instant_doctor_state.dart';

class InstantDoctorScreenErrorListener extends StatelessWidget {
  const InstantDoctorScreenErrorListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<InstantDoctorCubit, InstantDoctorState>(
      listenWhen: (previous, current) =>
          previous.loadingStateStatus != current.loadingStateStatus ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final errorMessage = state.errorMessage;
        if (state.loadingStateStatus == StateStatus.error &&
            errorMessage != null &&
            errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      },
      child: child,
    );
  }
}
