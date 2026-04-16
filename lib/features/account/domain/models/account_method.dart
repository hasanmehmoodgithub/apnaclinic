import 'dart:convert';

class AccountMethod {
  const AccountMethod({
    required this.bankName,
    required this.accountHolderName,
    required this.accountNumber,
    this.isDefault = false,
  });

  final String bankName;
  final String accountHolderName;
  final String accountNumber;
  final bool isDefault;

  String get maskedSubtitle => accountNumber;

  AccountMethod copyWith({
    String? bankName,
    String? accountHolderName,
    String? accountNumber,
    bool? isDefault,
  }) {
    return AccountMethod(
      bankName: bankName ?? this.bankName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'bankName': bankName,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'isDefault': isDefault,
    };
  }

  factory AccountMethod.fromJson(Map<String, dynamic> json) {
    return AccountMethod(
      bankName: (json['bankName'] ?? '').toString(),
      accountHolderName: (json['accountHolderName'] ?? '').toString(),
      accountNumber: (json['accountNumber'] ?? '').toString(),
      isDefault: json['isDefault'] == true,
    );
  }

  static String encodeList(List<AccountMethod> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }

  static List<AccountMethod> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((e) => AccountMethod.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
