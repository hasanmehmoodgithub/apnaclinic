import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/models/profile_setup_data.dart';
import '../cubit/profile_setup_cubit.dart';
import '../cubit/profile_setup_state.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileSetupCubit>(),
      child: const _ProfileSetupView(),
    );
  }
}

class _ProfileSetupView extends StatefulWidget {
  const _ProfileSetupView();

  @override
  State<_ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<_ProfileSetupView> {
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
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked == null || !context.mounted) return;
    context.read<ProfileSetupCubit>().setDateOfBirth(picked);
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
      contentPadding: const EdgeInsets.only(bottom: 10),
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
                    height: 260,
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
                        height: topInset + 48,
                        child: Padding(
                          padding: EdgeInsets.only(top: topInset + 4),
                          child: Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    if (context.canPop()) {
                                      context.pop();
                                    } else {
                                      context.go(
                                        AppRoutes.path(AppRoutes.authLogin),
                                      );
                                    }
                                  },
                                  child: const SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back_rounded,
                                        color: Color(0xFF061E40),
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 40),
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
                      const SizedBox(height: 8),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 56,
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
                                ? const Icon(
                                    Icons.account_circle_rounded,
                                    size: 56,
                                    color: Color(0xFFBFD5D9),
                                  )
                                : null,
                          ),
                          Positioned(
                            right: 2,
                            bottom: 4,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: _pickProfileImage,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDDF3EE),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 16,
                                    color: Color(0xFF0FAA9A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
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
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.profileSetupSubtitle,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF98A2B3),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
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
                                  const SizedBox(height: 22),
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
                                  const SizedBox(height: 22),
                                  Text(
                                    l10n.profileGenderLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF98A2B3),
                                    ),
                                  ),
                                  DropdownButtonFormField<String>(
                                    key: ValueKey(state.selectedGender),
                                    initialValue: state.selectedGender,
                                    decoration: _lineInputDecoration(
                                      context,
                                      hintText: l10n.profileGenderHint,
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: 'male',
                                        child: Text(l10n.profileGenderMale),
                                      ),
                                      DropdownMenuItem(
                                        value: 'female',
                                        child: Text(l10n.profileGenderFemale),
                                      ),
                                      DropdownMenuItem(
                                        value: 'other',
                                        child: Text(l10n.profileGenderOther),
                                      ),
                                    ],
                                    onChanged: context
                                        .read<ProfileSetupCubit>()
                                        .setGender,
                                  ),
                                  const SizedBox(height: 22),
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
                                  const SizedBox(height: 22),
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
                                  const SizedBox(height: 22),
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
                                          suffixIcon: const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 18,
                                            color: Color(0xFF98A2B3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (state.errorMessage != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      state.errorMessage!,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: const Color(0xFFE01F26),
                                          ),
                                    ),
                                  ],
                                  const SizedBox(height: 26),
                                  AppButton.primary(
                                    text: l10n.profileSaveCta,
                                    onPressed: state.isSaving
                                        ? null
                                        : () => _save(state),
                                    isLoading: state.isSaving,
                                    backgroundColor: const Color(0xFF0FAA9A),
                                    foregroundColor: Colors.white,
                                    height: 52,
                                    borderRadius: 12,
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
