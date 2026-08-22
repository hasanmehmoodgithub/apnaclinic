import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../account/domain/entities/account_item_entity.dart';
import '../../../account/presentation/add_account_launch_source.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../helpers/profile_account_mapper.dart';
import '../profile_setup_launch_source.dart';
import '../widgets/profile_header_bar.dart';
import '../widgets/profile_remove_account_dialog.dart';
import '../widgets/profile_screen_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.showBackButton = true, this.onBack});

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.profileRevision != current.profileRevision,
      builder: (context, _) {
        final cubit = context.read<ProfileCubit>();
        final viewData = cubit.viewData;

        return Scaffold(
          backgroundColor: AppColors.clrC7EFEB,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                ProfileHeaderBar(
                  showBackButton: showBackButton,
                  onBack: onBack ?? () => context.pop(),
                ),
                ProfileScreenHeader(imageUrl: viewData.imageUrl),
                ProfileScreenBody(
                  viewData: viewData,
                  onEditTap: () => _openProfileSetup(context),
                  onAddAccountTap: () => _openAddAccount(context),
                  onLoginTap: () => AuthGuard.pushLogin(context),
                  onDeleteAccountDetailTap: (index, item) =>
                      _deleteAccountDetail(context, item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openProfileSetup(BuildContext context) async {
    final updated = await context.push<bool>(
      AppRoutes.path(AppRoutes.profileSetup),
      extra: ProfileSetupLaunchSource.menu,
    );
    if (!context.mounted || updated != true) return;
    await context.read<ProfileCubit>().refreshProfile(force: true);
    await context.read<ProfileCubit>().loadAccounts(force: true);
  }

  Future<void> _openAddAccount(BuildContext context) async {
    final addedPhone = await context.push<String>(
      AppRoutes.path(AppRoutes.addAccount),
      extra: AddAccountLaunchSource.profile,
    );
    if (!context.mounted) return;

    final phone = addedPhone?.trim() ?? '';
    if (phone.isEmpty) return;

    await context.push<Object?>(
      AppRoutes.path(AppRoutes.accountDetails),
      extra: <String, dynamic>{
        'showSuccessDialog': true,
        'addedPhone': phone,
      },
    );
    if (!context.mounted) return;
    // Details already GETs phones and markSynced; reuse cache (no extra GET).
    await context.read<ProfileCubit>().loadAccounts();
  }

  Future<void> _deleteAccountDetail(
    BuildContext context,
    AccountItemEntity item,
  ) async {
    if (item.isDefault) return;

    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ProfileCubit>();
    final account = mapProfileAccountItem(
      l10n: l10n,
      item: item,
      fullName: cubit.viewData.fullName,
    );

    final confirmed = await showProfileRemoveAccountDialog(
      context,
      account: account,
    );
    if (!confirmed || !context.mounted) return;

    final error = await cubit.deleteAccount(
      item.id,
      displayNumber: item.number,
    );
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }
}
