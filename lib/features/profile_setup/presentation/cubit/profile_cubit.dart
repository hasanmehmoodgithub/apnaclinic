import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
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
  }) : super(const ProfileState()) {
    _initialize();
  }

  final AppPref appPref;
  final GetProfileSetupContentUseCase getProfileSetupContentUseCase;
  final GetAccountsListUseCase getAccountsListUseCase;
  final DeleteUserPhoneUseCase deleteUserPhoneUseCase;

  bool get isLoggedIn => AuthGuard.isLoggedIn(appPref);

  ProfileViewData get viewData => ProfileViewData.fromAppPref(appPref);

  Future<void> _initialize() async {
    await Future.wait([
      refreshProfile(),
      loadAccounts(),
    ]);
  }

  Future<void> refreshProfile() async {
    if (!isLoggedIn) {
      emit(state.copyWith(profileRevision: state.profileRevision + 1));
      return;
    }

    await getProfileSetupContentUseCase.call();
    emit(state.copyWith(profileRevision: state.profileRevision + 1));
  }

  Future<void> loadAccounts() async {
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

  Future<String?> deleteAccount(String phoneId) async {
    final result = await deleteUserPhoneUseCase(
      DeleteUserPhoneParams(phoneId: phoneId),
    );

    return result.fold(
      (error) => error,
      (_) {
        loadAccounts();
        return null;
      },
    );
  }
}
