import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../account/domain/entities/account_item_entity.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../models/profile_view_data.dart';
import 'guest_profile_content.dart';
import 'logged_in_profile_content.dart';
import 'profile_avatar_section.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({
    super.key,
    required this.viewData,
    required this.onEditTap,
    required this.onAddAccountTap,
    required this.onLoginTap,
    required this.onDeleteAccountDetailTap,
  });

  final ProfileViewData viewData;
  final VoidCallback onEditTap;
  final VoidCallback onAddAccountTap;
  final VoidCallback onLoginTap;
  final void Function(int index, AccountItemEntity item) onDeleteAccountDetailTap;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
        ),
        child: cubit.isLoggedIn
            ? BlocSelector<ProfileCubit, ProfileState, (StateStatus, String?)>(
                selector: (state) => (state.accountsStatus, state.accountsError),
                builder: (context, accountMeta) {
                  final accountsStatus = accountMeta.$1;
                  final accountsError = accountMeta.$2;

                  return BlocSelector<ProfileCubit, ProfileState,
                      List<AccountItemEntity>>(
                    selector: (state) => state.accounts,
                    builder: (context, accounts) {
                      return LoggedInProfileContent(
                        viewData: viewData,
                        accounts: accounts,
                        isAccountsLoading:
                            accountsStatus == StateStatus.loading,
                        accountsError: accountsError,
                        onDeleteAccount: onDeleteAccountDetailTap,
                        onEditTap: onEditTap,
                        onAddAccountTap: onAddAccountTap,
                      );
                    },
                  );
                },
              )
            : GuestProfileContent(onLoginTap: onLoginTap),
      ),
    );
  }
}

class ProfileScreenHeader extends StatelessWidget {
  const ProfileScreenHeader({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        ProfileAvatarSection(imageUrl: imageUrl),
        SizedBox(height: 20.h),
      ],
    );
  }
}
