import '../models/consultation_category_model.dart';
import 'consultation_local_data_source.dart';

class ConsultationLocalDataSourceImpl implements ConsultationLocalDataSource {
  @override
  Future<List<ConsultationCategoryModel>> getCategories() async {
    return _mockCategories
        .map(ConsultationCategoryModel.fromMap)
        .toList(growable: false);
  }
}

const List<Map<String, dynamic>> _mockCategories = [
  {
    'id': 'general_internal',
    'title': 'General & Internal Medicine',
    'description':
        "General & Internal Medicine focuses on adult prevention, diagnosis, and treatment across a wide range of conditions.",
    'iconUrl': 'assets/img/consultation/cat_general.svg',
  },
  {
    'id': 'pediatrics',
    'title': 'Children\'s Health (Pediatrics)',
    'description':
        'Pediatrics supports infants, children, and adolescents with routine and specialized healthcare.',
    'iconUrl': 'assets/img/consultation/cat_pediatrics.svg',
  },
  {
    'id': 'womens_health',
    'title': 'Women\'s Health',
    'description':
        'Women\'s Health includes gynecology, reproductive care, and hormone health support.',
    'iconUrl': 'assets/img/consultation/cat_women.svg',
  },
  {
    'id': 'mental_health',
    'title': 'Mental Health & Counseling',
    'description':
        'Mental Health & Counseling provides therapy and psychiatric care for emotional wellbeing.',
    'iconUrl': 'assets/img/consultation/cat_mental.svg',
  },
  {
    'id': 'skin_hair',
    'title': 'Skin, Hair & Aesthetics',
    'description':
        'Skin and aesthetics care for dermatology, hair concerns, and cosmetic procedures.',
    'iconUrl': 'assets/img/consultation/cat_skin.svg',
  },
  {
    'id': 'bones_muscles',
    'title': 'Bones, Muscles & Movement',
    'description':
        'Orthopedic and musculoskeletal support for pain, injuries, and mobility conditions.',
    'iconUrl': 'assets/img/consultation/cat_bones.svg',
  },
  {
    'id': 'heart_lungs',
    'title': 'Heart & Lungs',
    'description':
        'Cardiology and pulmonology specialists for chest, breathing, and circulation concerns.',
    'iconUrl': 'assets/img/consultation/cat_heart.svg',
  },
  {
    'id': 'stomach_liver_kidneys',
    'title': 'Stomach, Liver & Kidneys',
    'description':
        'Digestive and renal care for gut, liver, and kidney related diseases.',
    'iconUrl': 'assets/img/consultation/cat_stomach.svg',
  },
];
