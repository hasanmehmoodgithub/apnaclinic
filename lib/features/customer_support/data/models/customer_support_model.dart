class CustomerSupportContactModel {
  const CustomerSupportContactModel({
    required this.cardTitle,
    required this.dialogTitle,
    required this.dialogMessage,
    required this.dialNumber,
  });

  final String cardTitle;
  final String dialogTitle;
  final String dialogMessage;
  final String dialNumber;

  factory CustomerSupportContactModel.fromJson(Map<String, dynamic> json) {
    return CustomerSupportContactModel(
      cardTitle: (json['cardTitle'] ?? json['title'] ?? '').toString(),
      dialogTitle: (json['dialogTitle'] ?? '').toString(),
      dialogMessage: (json['dialogMessage'] ?? json['message'] ?? '').toString(),
      dialNumber: (json['dialNumber'] ?? json['phone'] ?? '').toString(),
    );
  }
}

class CustomerSupportPayloadModel {
  const CustomerSupportPayloadModel({
    required this.helpCentreTitle,
    required this.helpCentreSubtitle,
    required this.contacts,
  });

  final String helpCentreTitle;
  final String helpCentreSubtitle;
  final List<CustomerSupportContactModel> contacts;

  factory CustomerSupportPayloadModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['contacts'] ?? json['items'] ?? json['supportOptions'];
    final list = rawList is List<dynamic> ? rawList : const <dynamic>[];
    return CustomerSupportPayloadModel(
      helpCentreTitle: (json['helpCentreTitle'] ?? json['helpTitle'] ?? '')
          .toString(),
      helpCentreSubtitle:
          (json['helpCentreSubtitle'] ?? json['helpSubtitle'] ?? '').toString(),
      contacts: list
          .whereType<Map<String, dynamic>>()
          .map(CustomerSupportContactModel.fromJson)
          .toList(),
    );
  }
}

class CustomerSupportResponseModel {
  const CustomerSupportResponseModel({
    required this.success,
    required this.message,
    required this.payload,
  });

  final bool success;
  final String message;
  final CustomerSupportPayloadModel payload;

  factory CustomerSupportResponseModel.fromJson(Map<String, dynamic> json) {
    final payloadMap = _payloadMap(json);
    return CustomerSupportResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      payload: CustomerSupportPayloadModel.fromJson(payloadMap),
    );
  }

  static Map<String, dynamic> _payloadMap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    final content = json['content'];
    if (content is Map<String, dynamic>) {
      return content;
    }
    final copy = Map<String, dynamic>.from(json)
      ..remove('success')
      ..remove('message');
    return copy;
  }
}
