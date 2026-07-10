/// How the user reached [AddAccountScreen]; drives post-save navigation.
enum AddAccountLaunchSource {
  profile,
  accountDetails,
  consultationCheckout,
}

AddAccountLaunchSource addAccountLaunchSourceFromExtra(Object? extra) {
  if (extra is AddAccountLaunchSource) return extra;
  return AddAccountLaunchSource.accountDetails;
}
