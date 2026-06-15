/// How the user reached [AddAccountScreen]; drives post-save navigation.
enum AddAccountLaunchSource {
  profile,
  accountDetails,
}

AddAccountLaunchSource addAccountLaunchSourceFromExtra(Object? extra) {
  if (extra is AddAccountLaunchSource) return extra;
  return AddAccountLaunchSource.accountDetails;
}
