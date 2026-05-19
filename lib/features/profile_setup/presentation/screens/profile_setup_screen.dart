import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../notification/presentation/widgets/profile_setup_loading_shimmer.dart';
import '../../domain/models/profile_setup_data.dart';
import '../cubit/profile_setup_cubit.dart';
import '../cubit/profile_setup_state.dart';
import '../widgets/profile_setup_avatar_picker.dart';
import '../widgets/profile_setup_form_section.dart';
import '../widgets/profile_setup_header_bar.dart';

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
  final appPref = sl<AppPref>();
  File? _selectedProfileImage;
  String? _remoteImageUrl;
  bool _hasAppliedInitialData = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileSetupCubit>().resetState();
    final userLocal = appPref.getUserLocalModel();
    _firstNameController.text = userLocal?.firstName.trim() ?? '';
    _lastNameController.text = userLocal?.lastName.trim() ?? '';
    _emailController.text = userLocal?.email.trim() ?? '';
    _addressController.text = userLocal?.address.trim() ?? '';
    final cachedImageUrl = userLocal?.imageUrl.trim() ?? '';
    _remoteImageUrl = cachedImageUrl.isEmpty ? null : cachedImageUrl;
    if (appPref.getLoginStatus() && appPref.isProfileCompleted()) {
      context.read<ProfileSetupCubit>().loadProfile();
    }
  }

  String? _resolveAvatarImageUrl(ProfileSetupState state) {
    final fromProfile = state.profile?.imageUrl?.trim() ?? '';
    if (fromProfile.isNotEmpty) return fromProfile;
    return _remoteImageUrl;
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.profileImagePickerRestartMessage,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.profileImagePickerFailedMessage,
          ),
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
              primary: AppColors.clr0FAA9A,
              onPrimary: AppColors.clrWhite,
              surface: AppColors.clrWhite,
              onSurface: AppColors.clr060,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppColors.clrWhite,
              headerBackgroundColor: AppColors.clr0FAA9A,
              headerForegroundColor: AppColors.clrWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              dayStyle: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr060,
              ),
              todayBorder: BorderSide(color: AppColors.clr0FAA9A, width: 1.r),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.clr0FAA9A,
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
                          color: AppColors.clr0FAA9A,
                          size: 20.r,
                        )
                      : null,
                  onTap: () => dialogContext.pop('male'),
                ),
                ListTile(
                  title: Text(l10n.profileGenderFemale),
                  trailing: selected == 'female'
                      ? Icon(
                          Icons.check_rounded,
                          color: AppColors.clr0FAA9A,
                          size: 20.r,
                        )
                      : null,
                  onTap: () => dialogContext.pop('female'),
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

    String? profileImagePath;
    final selectedImage = _selectedProfileImage;
    if (selectedImage != null) {
      profileImagePath = selectedImage.path;
    }
    if (!mounted) return;

    final isUpdateMode = appPref.isProfileCompleted();
    final success = await context.read<ProfileSetupCubit>().saveProfile(
      ProfileSetupData(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: state.selectedGender!,
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        dateOfBirth: state.dateOfBirth!,
        profileImagePath: profileImagePath,
      ),
    );
    if (!mounted || !success) return;
    if (isUpdateMode) {
      await context.read<ProfileSetupCubit>().loadProfile();
      if (!mounted) return;
      if (context.canPop()) {
        context.pop(true);
        return;
      }
    }
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
    bool isValueText = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: isValueText ? AppColors.clr101828 : AppColors.clr667085,
      ),
      isDense: true,
      contentPadding: EdgeInsets.only(bottom: 10.h),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.clrD0D5DD),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.clr0FAA9A, width: 1.5),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topInset = MediaQuery.paddingOf(context).top;
    final isInitialLoading = context.select(
      (ProfileSetupCubit cubit) =>
          cubit.state.loadingStateStatus == StateStatus.loading &&
          !_hasAppliedInitialData,
    );

    return Scaffold(
      backgroundColor: isInitialLoading
          ? AppColors.clrWhite
          : AppColors.clrC7EFEB,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocConsumer<ProfileSetupCubit, ProfileSetupState>(
            listener: (context, state) {
              final profile = state.profile;
              if (profile == null || _hasAppliedInitialData) return;
              _firstNameController.text = profile.firstName;
              _lastNameController.text = profile.lastName;
              _emailController.text = profile.email;
              _addressController.text = profile.address;
              final imageUrl = profile.imageUrl?.trim() ?? '';
              if (imageUrl.isNotEmpty) {
                _remoteImageUrl = imageUrl;
              }
              _hasAppliedInitialData = true;
            },
            builder: (context, state) {
              final showInitialLoading =
                  state.loadingStateStatus == StateStatus.loading &&
                  !_hasAppliedInitialData;
              if (showInitialLoading) {
                return const ProfileSetupLoadingShimmer();
              }
              final dobLabel = state.dateOfBirth == null
                  ? l10n.profileDobHint
                  : DateFormat('MMM dd yyyy').format(state.dateOfBirth!);
              final isUpdateMode = appPref.isProfileCompleted();
              return Stack(
                children: [
                  Column(
                    children: [
                      ProfileSetupHeaderBar(topInset: topInset),
                      SizedBox(height: 8.h),
                      ProfileSetupAvatarPicker(
                        imageUrl: _resolveAvatarImageUrl(state),
                        selectedImageFile: _selectedProfileImage,
                        onPickImage: _pickProfileImage,
                      ),
                      SizedBox(height: 14.h),
                      ProfileSetupFormSection(
                        formKey: _formKey,
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        emailController: _emailController,
                        addressController: _addressController,
                        state: state,
                        dobLabel: dobLabel,
                        onPickGender: () => _showGenderPicker(context),
                        onPickDate: () => _pickDate(context),
                        onSave: () => _save(state),
                        isUpdateMode: isUpdateMode,
                        inputDecorationBuilder:
                            ({
                              required String hintText,
                              Widget? suffixIcon,
                              bool isValueText = false,
                            }) {
                              return _lineInputDecoration(
                                context,
                                hintText: hintText,
                                suffixIcon: suffixIcon,
                                isValueText: isValueText,
                              );
                            },
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
