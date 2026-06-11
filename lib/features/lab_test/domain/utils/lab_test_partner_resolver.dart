class LabTestPartnerResolver {
  LabTestPartnerResolver._();

  static String partnerIdForLabSlug(String labSlug) {
    final slug = labSlug.trim().toLowerCase();
    if (slug.contains('mediq')) return '1';
    if (slug.contains('oladoc') || slug == 'excel-lab' || slug == 'chughtai-lab') {
      return '2';
    }
    return '3';
  }
}
