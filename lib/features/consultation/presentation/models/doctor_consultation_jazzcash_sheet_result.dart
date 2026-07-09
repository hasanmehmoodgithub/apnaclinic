class DoctorConsultationJazzCashSheetResult {
  const DoctorConsultationJazzCashSheetResult._({
    required this.msisdn,
    required this.addAccount,
  });

  const DoctorConsultationJazzCashSheetResult.account({
    required String msisdn,
  })  : msisdn = msisdn,
        addAccount = false;

  const DoctorConsultationJazzCashSheetResult.addAccount()
      : msisdn = null,
        addAccount = true;

  final String? msisdn;
  final bool addAccount;
}
