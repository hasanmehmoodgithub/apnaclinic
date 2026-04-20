import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/models/profile_setup_data.dart';
import '../cubit/profile_setup_cubit.dart';
import '../cubit/profile_setup_state.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedProfileImage;

  ImageProvider? get _avatarProvider {
    if (_selectedProfileImage != null) {
      return FileImage(_selectedProfileImage!);
    }
    return null;
  }

  Future<void> _pickProfileImage() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (picked == null || !mounted) return;
      setState(() => _selectedProfileImage = File(picked.path));
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Image picker not ready yet. Please fully restart the app.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not pick image. Please try again.'),
        ),
      );
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final state = context.read<ProfileSetupCubit>().state;
    final now = DateTime.now();
    final initial =
        state.dateOfBirth ?? DateTime(now.year - 20, now.month, now.day);
    final theme = Theme.of(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: const Color(0xFF0FAA9A),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF061E40),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: const Color(0xFF0FAA9A),
              headerForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              dayStyle: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF061E40),
              ),
              todayBorder: BorderSide(
                color: const Color(0xFF0FAA9A),
                width: 1.r,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0FAA9A),
                textStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked == null || !context.mounted) return;
    context.read<ProfileSetupCubit>().setDateOfBirth(picked);
  }

  Future<void> _showGenderPicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final selected = context.read<ProfileSetupCubit>().state.selectedGender;
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(l10n.profileGenderMale),
                  trailing: selected == 'male'
                      ? Icon(
                          Icons.check_rounded,
                          color: const Color(0xFF0FAA9A),
                          size: 20.r,
                        )
                      : null,
                  onTap: () => Navigator.of(dialogContext).pop('male'),
                ),
                ListTile(
                  title: Text(l10n.profileGenderFemale),
                  trailing: selected == 'female'
                      ? Icon(
                          Icons.check_rounded,
                          color: const Color(0xFF0FAA9A),
                          size: 20.r,
                        )
                      : null,
                  onTap: () => Navigator.of(dialogContext).pop('female'),
                ),
                ListTile(
                  title: Text(l10n.profileGenderOther),
                  trailing: selected == 'other'
                      ? Icon(
                          Icons.check_rounded,
                          color: const Color(0xFF0FAA9A),
                          size: 20.r,
                        )
                      : null,
                  onTap: () => Navigator.of(dialogContext).pop('other'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == null || !context.mounted) return;
    context.read<ProfileSetupCubit>().setGender(result);
    FocusScope.of(context).unfocus();
  }

  Future<void> _save(ProfileSetupState state) async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (state.selectedGender == null || state.selectedGender!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.profileGenderRequired)));
      return;
    }
    if (state.dateOfBirth == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.profileDobRequired)));
      return;
    }

    final success = await context.read<ProfileSetupCubit>().saveProfile(
      ProfileSetupData(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: state.selectedGender!,
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        dateOfBirth: state.dateOfBirth!,
      ),
    );
    if (!mounted || !success) return;
    context.go(AppRoutes.path(AppRoutes.home));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  InputDecoration _lineInputDecoration(
    BuildContext context, {
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF667085)),
      isDense: true,
      contentPadding: EdgeInsets.only(bottom: 10.h),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD0D5DD)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF0FAA9A), width: 1.5),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
            builder: (context, state) {
              final dobLabel = state.dateOfBirth == null
                  ? l10n.profileDobHint
                  : DateFormat('dd/MM/yy').format(state.dateOfBirth!);
              final avatarProvider = _avatarProvider;
              return Stack(
                children: [
                  SizedBox(
                    height: 260.h,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF87DDD3), Color(0xFFF4F5F7)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: topInset + 48.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: topInset + 4.h),
                          child: Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20.r),
                                  onTap: () {
                                    if (context.canPop()) {
                                      context.pop();
                                    } else {
                                      context.go(
                                        AppRoutes.path(AppRoutes.authLogin),
                                      );
                                    }
                                  },
                                  child: SizedBox(
                                    width: 40.r,
                                    height: 40.r,
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back_rounded,
                                        color: Color(0xFF061E40),
                                        size: 22.r,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 40.w),
                                    child: Text(
                                      l10n.profileTitle,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF061E40),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 56.r,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.95,
                            ),
                            backgroundImage: avatarProvider,
                            onBackgroundImageError: avatarProvider == null
                                ? null
                                : (_, _) {
                                    if (!mounted) return;
                                    setState(() => _selectedProfileImage = null);
                                  },
                            child: avatarProvider == null
                                ? Icon(
                                    Icons.account_circle_rounded,
                                    size: 56.r,
                                    color: Color(0xFFBFD5D9),
                                  )
                                : null,
                          ),
                          Positioned(
                            right: 2.w,
                            bottom: 4.h,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16.r),
                                onTap: _pickProfileImage,
                                child: Container(
                                  padding: EdgeInsets.all(6.r),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDDF3EE),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 16.r,
                                    color: Color(0xFF0FAA9A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24.r),
                            ),
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    l10n.profileSetupTitle,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF061E40),
                                        ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    l10n.profileSetupSubtitle,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF98A2B3),
                                    ),
                                  ),
                                  SizedBox(height: 18.h),
                                  Text(
                                    l10n.profileFirstNameLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF98A2B3),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _firstNameController,
                                    decoration: _lineInputDecoration(
                                      context,
                                      hintText: l10n.profileFirstNameHint,
                                    ),
                                    validator: (value) {
                                      if ((value ?? '').trim().isEmpty) {
                                        return l10n.profileFirstNameRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 22.h),
                                  Text(
                                    l10n.profileLastNameLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF98A2B3),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _lastNameController,
                                    decoration: _lineInputDecoration(
                                      context,
                                      hintText: l10n.profileLastNameHint,
                                    ),
                                    validator: (value) {
                                      if ((value ?? '').trim().isEmpty) {
                                        return l10n.profileLastNameRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 22.h),
                                  Text(
                                    l10n.profileGenderLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF98A2B3),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _showGenderPicker(context),
                                    child: IgnorePointer(
                                      child: TextFormField(
                                        decoration: _lineInputDecoration(
                                          context,
                                          hintText: state.selectedGender == null
                                              ? l10n.profileGenderHint
                                              : state.selectedGender == 'male'
                                              ? l10n.profileGenderMale
                                              : state.selectedGender == 'female'
                                              ? l10n.profileGenderFemale
                                              : l10n.profileGenderOther,
                                          suffixIcon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: const Color(0xFF0FAA9A),
                                            size: 22.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 22.h),
                                  Text(
                                    l10n.profileEmailLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF98A2B3),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: _lineInputDecoration(
                                      context,
                                      hintText: l10n.profileEmailHint,
                                    ),
                                    validator: (value) {
                                      final email = (value ?? '').trim();
                                      if (email.isEmpty ||
                                          !email.contains('@')) {
                                        return l10n.profileEmailRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 22.h),
                                  Text(
                                    l10n.profileAddressLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF98A2B3),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _addressController,
                                    decoration: _lineInputDecoration(
                                      context,
                                      hintText: l10n.profileAddressHint,
                                    ),
                                    validator: (value) {
                                      if ((value ?? '').trim().isEmpty) {
                                        return l10n.profileAddressRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 22.h),
                                  Text(
                                    l10n.profileDobLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF98A2B3),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _pickDate(context),
                                    child: IgnorePointer(
                                      child: TextFormField(
                                        decoration: _lineInputDecoration(
                                          context,
                                          hintText: dobLabel,
                                          suffixIcon: Icon(
                                            Icons.calendar_today_outlined,
                                            size: 18.r,
                                            color: Color(0xFF98A2B3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (state.errorMessage != null) ...[
                                    SizedBox(height: 12.h),
                                    Text(
                                      state.errorMessage!,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: const Color(0xFFE01F26),
                                          ),
                                    ),
                                  ],
                                  SizedBox(height: 26.h),
                                  AppButton.primary(
                                    text: l10n.profileSaveCta,
                                    onPressed: state.isSaving
                                        ? null
                                        : () => _save(state),
                                    isLoading: state.isSaving,
                                    backgroundColor: const Color(0xFF0FAA9A),
                                    foregroundColor: Colors.white,
                                    height: 52.h,
                                    borderRadius: 12.r,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
