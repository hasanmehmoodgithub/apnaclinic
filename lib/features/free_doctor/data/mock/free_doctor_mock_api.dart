class FreeDoctorMockApi {
  Future<Map<String, dynamic>> getFreeDoctorData() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {
      'title': '24/7 Free Doctor Consultation',
      'descriptionPoints': [
        'This service is available exclusively for Bima m-Health subscribers.',
        'Get 24/7 access to qualified doctors for general medical support and much more.',
        'To avail the service, subscribe to BIMA m-Health via FikrFree.',
      ],
      'fikrfreeAndroidPackage': 'com.fikrfree.android',
      'fikrfreeIosAppStoreUrl':
          'https://apps.apple.com/pk/app/fikrfree/id6738691924',
      'fikrfreeWebUrl': 'https://www.fikrfree.com',
    };
  }
}
