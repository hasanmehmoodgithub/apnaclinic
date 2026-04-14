import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';

class DashboardProfileScreen extends StatelessWidget {
  const DashboardProfileScreen({
    super.key,
    this.showBackButton = true,
    this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoggedIn = sl<AppPref>().getLoginStatus();
    final appPref = sl<AppPref>();
    final firstName = (appPref.getString('profile_first_name') ?? '').trim();
    final lastName = (appPref.getString('profile_last_name') ?? '').trim();
    final fullName = '$firstName $lastName'.trim();
    final phone = (appPref.getString('profile_phone') ?? '').trim();
    final gender = (appPref.getString('profile_gender') ?? '').trim();
    final email = (appPref.getString('profile_email') ?? '').trim();
    final dobIso = (appPref.getString('profile_dob') ?? '').trim();
    final dob = DateTime.tryParse(dobIso);
    final dobLabel = dob == null
        ? ''
        : '${dob.day.toString().padLeft(2, '0')} '
              '${_monthShort(dob.month)} ${dob.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFC7EFEB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
              child: Row(
                children: [
                  showBackButton
                      ? IconButton(
                          onPressed:
                              onBack ?? () => Navigator.of(context).maybePop(),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF061E40),
                          ),
                        )
                      : const SizedBox(width: 48),
                  Expanded(
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF061E40),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.96),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 126,
                    height: 126,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: 68,
                        color: Colors.grey
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 122,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(79, 109, 138, 0.35),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6F8),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(42)),
                ),
                child: isLoggedIn
                    ? ListView(
                        padding: const EdgeInsets.fromLTRB(18, 26, 18, 24),
                        children: [
                          const SizedBox(height: 28),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fullName.isEmpty ? 'User' : fullName,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        color: const Color(0xFF1A2A4A),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 38 / 1.6,
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      phone.isEmpty ? '--' : phone,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: const Color(0xFF7A8594),
                                        fontSize: 16,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(18),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFE4E7EB),
                                          border: Border.all(
                                            color: const Color(0xFFC2C9D2),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.edit_rounded,
                                          size: 10,
                                          color: Color(0xFF7B8794),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Edit',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: const Color(0xFF3D4C63),
                                          fontSize: 22 / 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _InfoTilesRow(
                            gender: gender.isEmpty ? '--' : gender,
                            dob: dobLabel.isEmpty ? '--' : dobLabel,
                            email: email.isEmpty ? '--' : email,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Account Details',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF2D2D2D),
                              fontWeight: FontWeight.w500,
                              fontSize: 16 / 1.05,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFD4D9E1),
                                width: 0.6,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Add Account',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: const Color(0xFF2C2F5A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFC6CCD5),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Color(0xFF2C2F5A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                            child: Container(
                              height: 100,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ),

                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFDDE5EF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Guest User',
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        color: const Color(0xFF1A2A4A),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () => context.push(
                                      AppRoutes.path(AppRoutes.authLogin),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(0, 40),
                                      side: const BorderSide(
                                        color: Color(0xFF8C949C),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                      ),
                                    ),
                                    child: Text(
                                      'Sign Up / Login',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: const Color(0xFF3A4557),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTilesRow extends StatelessWidget {
  const _InfoTilesRow({
    required this.gender,
    required this.dob,
    required this.email,
  });

  final String gender;
  final String dob;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(title: 'Gender', value: gender),
        ),
        SizedBox(width: 6),
        Expanded(
          child: _InfoTile(title: 'Date of Birth', value: dob),
        ),
        SizedBox(width: 6),
        Expanded(
          child: _InfoTile(title: 'Email', value: email),
        ),
      ],
    );
  }
}

String _monthShort(int month) {
  const names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return names[(month - 1).clamp(0, 11)];
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFC9CFD7), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF7A91AE),
              fontSize: 12 / 1.05,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF2B2C58),
              fontWeight: FontWeight.w500,
              fontSize: 26 / 1.6,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
