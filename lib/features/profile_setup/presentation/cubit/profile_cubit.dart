import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/session/profile_session_sync.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../account/domain/use_cases/delete_user_phone_use_case.dart';
import '../../../account/domain/use_cases/get_accounts_list_use_case.dart';
import '../../domain/use_cases/get_profile_setup_content_use_case.dart';
import '../models/profile_view_data.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.appPref,
    required this.getProfileSetupContentUseCase,
    required this.getAccountsListUseCase,
    required this.deleteUserPhoneUseCase,
    ProfileSessionSync? profileSessionSync,
  })  : _profileSessionSync = profileSessionSync ?? sl<ProfileSessionSync>(),
        super(const ProfileState()) {
    _initialize();
  }

  final AppPref appPref;
  final GetProfileSetupContentUseCase getProfileSetupContentUseCase;
  final GetAccountsListUseCase getAccountsListUseCase;
  final DeleteUserPhoneUseCase deleteUserPhoneUseCase;
  final ProfileSessionSync _profileSessionSync;

  bool get isLoggedIn => AuthGuard.isLoggedIn(appPref);

  ProfileViewData get viewData => ProfileViewData.fromAppPref(appPref);

  Future<void> _initialize() async {
    if (!isLoggedIn) {
      emit(state.copyWith(profileRevision: state.profileRevision + 1));
      return;
    }

    emit(state.copyWith(profileRevision: state.profileRevision + 1));

    if (_profileSessionSync.shouldSkipNetworkFetch(appPref)) {
      _emitCachedAccounts();
      return;
    }

    await refreshProfile(force: true);
  }

  Future<void> refreshProfile({bool force = false}) async {
    if (!isLoggedIn) {
      emit(state.copyWith(profileRevision: state.profileRevision + 1));
      return;
    }

    if (!force && _profileSessionSync.shouldSkipNetworkFetch(appPref)) {
      emit(state.copyWith(profileRevision: state.profileRevision + 1));
      _emitCachedAccounts();
      return;
    }

    final result = await getProfileSetupContentUseCase.call();
    emit(state.copyWith(profileRevision: state.profileRevision + 1));
    result.fold(
      (_) {},
      (_) => _emitCachedAccounts(),
    );
  }

  Future<void> loadAccounts({bool force = false}) async {
    if (!isLoggedIn) return;

    if (!force && _profileSessionSync.shouldSkipNetworkFetch(appPref)) {
      _emitCachedAccounts();
      return;
    }

    emit(
      state.copyWith(
        accountsStatus: StateStatus.loading,
        accountsError: null,
      ),
    );

    final result = await getAccountsListUseCase.call();
    result.fold(
      (error) => emit(
        state.copyWith(
          accountsStatus: StateStatus.error,
          accountsError: error,
        ),
      ),
      (accounts) => emit(
        state.copyWith(
          accountsStatus: StateStatus.success,
          accounts: accounts,
          accountsError: null,
        ),
      ),
    );
  }

  void _emitCachedAccounts() {
    emit(
      state.copyWith(
        accountsStatus: StateStatus.success,
        accounts: _profileSessionSync.cachedAccounts,
        accountsError: null,
      ),
    );
  }

  Future<String?> deleteAccount(String phoneId, {String? displayNumber}) async {
    var resolvedPhoneId = phoneId.trim();

    // Profile GET cache previously omitted phone ids; refresh list if missing.
    if (resolvedPhoneId.isEmpty) {
      await loadAccounts(force: true);
      final number = displayNumber?.trim() ?? '';
      if (number.isNotEmpty) {
        for (final account in state.accounts) {
          if (account.number == number && account.id.trim().isNotEmpty) {
            resolvedPhoneId = account.id.trim();
            break;
          }
        }
      }
    }

    final result = await deleteUserPhoneUseCase(
      DeleteUserPhoneParams(phoneId: resolvedPhoneId),
    );

    return result.fold(
      (error) => error,
      (_) {
        loadAccounts(force: true);
        return null;
      },
    );
  }
}
