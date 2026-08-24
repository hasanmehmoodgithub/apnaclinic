class SupportSettingsLocalModel {
  const SupportSettingsLocalModel({
    this.id,
    this.phone = '',
    this.email = '',
    this.description = '',
    this.buttonText = '',
    this.faqsUrl = '',
    this.privacyPolicyUrl = '',
    this.termsAndConditionsUrl = '',
    this.updatedAt = '',
  });

  final int? id;
  final String phone;
  final String email;
  final String description;
  final String buttonText;
  final String faqsUrl;
  final String privacyPolicyUrl;
  final String termsAndConditionsUrl;
  final String updatedAt;

  bool get hasContactData =>
      phone.isNotEmpty || email.isNotEmpty || description.isNotEmpty;

  factory SupportSettingsLocalModel.fromJson(Map<String, dynamic> json) {
    return SupportSettingsLocalModel(
      id: _toInt(json['id']),
      phone: _str(json['phone']),
      email: _str(json['email']),
      description: _str(json['description']),
      buttonText: _str(json['buttonText'] ?? json['button_text']),
      faqsUrl: _str(json['faqsUrl'] ?? json['faqs_url']),
      privacyPolicyUrl: _str(
        json['privacyPolicyUrl'] ?? json['privacy_policy_url'],
      ),
      termsAndConditionsUrl: _str(
        json['termsAndConditionsUrl'] ?? json['terms_and_conditions_url'],
      ),
      updatedAt: _str(json['updatedAt'] ?? json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'description': description,
      'buttonText': buttonText,
      'faqsUrl': faqsUrl,
      'privacyPolicyUrl': privacyPolicyUrl,
      'termsAndConditionsUrl': termsAndConditionsUrl,
      'updatedAt': updatedAt,
    };
  }

  static String _str(dynamic value) => (value ?? '').toString().trim();

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}
