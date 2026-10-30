import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/apna_clinic_ai_urls.dart';
import '../constants/apna_clinic_ai_ui_config.dart';
import '../cubit/apna_clinic_ai_cubit.dart';

/// Runtime override for `AI_BASE_URL` / `AI_SDK_KEY` (and `APNA_CLINIC_AI_*`).
Future<void> showApnaClinicAiSdkEndpointDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<ApnaClinicAiCubit>(),
      child: const _ApnaClinicAiSdkEndpointDialog(),
    ),
  );
}

class _ApnaClinicAiSdkEndpointDialog extends StatefulWidget {
  const _ApnaClinicAiSdkEndpointDialog();

  @override
  State<_ApnaClinicAiSdkEndpointDialog> createState() =>
      _ApnaClinicAiSdkEndpointDialogState();
}

class _ApnaClinicAiSdkEndpointDialogState
    extends State<_ApnaClinicAiSdkEndpointDialog> {
  late final TextEditingController _baseUrl;
  late final TextEditingController _sdkKey;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final config = sl<ApnaClinicAiConfig>();
    _baseUrl = TextEditingController(text: config.baseUrl);
    _sdkKey = TextEditingController(text: config.sdkKey);
  }

  @override
  void dispose() {
    _baseUrl.dispose();
    _sdkKey.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final base = _baseUrl.text.trim();
    final key = _sdkKey.text.trim();
    if (base.isEmpty || key.isEmpty) return;
    setState(() => _saving = true);
    await context.read<ApnaClinicAiCubit>().applySdkEndpoint(
      baseUrl: base,
      sdkKey: key,
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _reset() async {
    if (_saving) return;
    setState(() => _saving = true);
    await context.read<ApnaClinicAiCubit>().resetSdkEndpointToEnvironment();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: ApnaClinicAiUiConfig.panel,
      title: Text(
        l10n.apnaClinicAiSdkEndpointTitle,
        style: theme.textTheme.titleMedium?.copyWith(
          color: ApnaClinicAiUiConfig.primaryText,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: SizedBox(
        width: 420.w,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.apnaClinicAiSdkEndpointHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ApnaClinicAiUiConfig.secondaryText,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 14.h),
              _Field(
                controller: _baseUrl,
                label: l10n.apnaClinicAiSdkBaseUrlLabel,
                helper: l10n.apnaClinicAiSdkBaseUrlKeys,
                enabled: !_saving,
              ),
              SizedBox(height: 12.h),
              _Field(
                controller: _sdkKey,
                label: l10n.apnaClinicAiSdkKeyLabel,
                helper: l10n.apnaClinicAiSdkKeyKeys,
                enabled: !_saving,
                obscure: true,
              ),
              SizedBox(height: 10.h),
              Text(
                l10n.apnaClinicAiSdkEndpointDefaults(
                  ApnaClinicAiUrls.defaultBaseUrl,
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ApnaClinicAiUiConfig.muted,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : _reset,
          child: Text(l10n.apnaClinicAiSdkEndpointReset),
        ),
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.profileCancelCta),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(
            backgroundColor: ApnaClinicAiUiConfig.cta,
          ),
          child: _saving
              ? SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.apnaClinicAiSdkEndpointApply),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.helper,
    required this.enabled,
    this.obscure = false,
  });

  final TextEditingController controller;
  final String label;
  final String helper;
  final bool enabled;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscure,
      autocorrect: false,
      enableSuggestions: false,
      style: TextStyle(
        color: ApnaClinicAiUiConfig.primaryText,
        fontSize: 13.sp,
      ),
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        helperMaxLines: 2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: ApnaClinicAiUiConfig.cta),
        ),
      ),
    );
  }
}
