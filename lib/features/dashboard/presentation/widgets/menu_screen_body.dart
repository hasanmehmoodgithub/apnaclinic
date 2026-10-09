import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../pro/domain/entities/pro_membership_entity.dart';
import '../helpers/menu_profile_mapper.dart';
import '../helpers/menu_screen_config.dart';
import 'menu_about_card.dart';
import 'menu_action_tile.dart';
import 'menu_pro_card.dart';
import 'menu_profile_card.dart';

class MenuScreenBody extends StatelessWidget {
  const MenuScreenBody({
    super.key,
    required this.profile,
    required this.actionItems,
    required this.aboutItems,
    required this.onProfileActionTap,
    required this.onActionTap,
    required this.onAboutTap,
    this.proMembership,
    this.onProTap,
    this.isProMembershipLoading = false,
  });

  final MenuProfileViewData profile;
  final List<MenuActionItem> actionItems;
  final List<MenuAboutItemData> aboutItems;
  final VoidCallback onProfileActionTap;
  final ValueChanged<MenuActionId> onActionTap;
  final VoidCallback onAboutTap;
  final ProMembershipEntity? proMembership;
  final VoidCallback? onProTap;
  final bool isProMembershipLoading;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 18.h),
      children: [
        MenuProfileCard(
          isLoggedIn: profile.isLoggedIn,
          name: profile.name,
          phone: profile.phone,
          imageUrl: profile.imageUrl,
          imageCacheKey: profile.imageCacheKey,
          isPro: proMembership?.isActivePro == true,
          onActionTap: onProfileActionTap,
        ),
        SizedBox(height: 14.h),
        if (isProMembershipLoading) ...[
          AppShimmerCard(height: 140.h, borderRadius: 16.r),
          SizedBox(height: 14.h),
        ] else ...[
          MenuProCard(
            membership: proMembership,
            onTap: onProTap,
          ),
          SizedBox(height: 14.h),
        ],
        for (final item in actionItems) ...[
          MenuActionTile(
            title: item.title,
            icon: item.icon,
            curveOverlayColor: item.curveOverlayColor,
            onTap: () => onActionTap(item.id),
          ),
          SizedBox(height: 14.h),
        ],
        MenuAboutCard(
          items: aboutItems,
          onAboutTap: onAboutTap,
        ),
      ],
    );
  }
}
