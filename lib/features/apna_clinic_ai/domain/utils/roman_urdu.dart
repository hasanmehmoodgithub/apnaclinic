/// Rewrites Roman Urdu (Latin letters) into native Urdu script.
class RomanUrdu {
  RomanUrdu._();

  static final RegExp _latinWord = RegExp(r"[A-Za-z']+");

  static const Map<String, String> _words = {
    'aaj': 'آج',
    'aap': 'آپ',
    'acha': 'اچھا',
    'achha': 'اچھا',
    'ab': 'اب',
    'agar': 'اگر',
    'aj': 'آج',
    'alaikum': 'علیکم',
    'allergy': 'الرجی',
    'ankh': 'آنکھ',
    'aankh': 'آنکھ',
    'ap': 'آپ',
    'appointment': 'اپائنٹمنٹ',
    'assalam': 'السلام',
    'assalamu': 'السلام',
    'aur': 'اور',
    'badan': 'بدن',
    'bahut': 'بہت',
    'bataen': 'بتائیں',
    'bataein': 'بتائیں',
    'batao': 'بتاؤ',
    'bazu': 'بازو',
    'bhi': 'بھی',
    'bimari': 'بیماری',
    'blood': 'خون',
    'bohot': 'بہت',
    'boht': 'بہت',
    'booking': 'بکنگ',
    'bukhaar': 'بخار',
    'bukhar': 'بخار',
    'chaiye': 'چاہیے',
    'chahiye': 'چاہیے',
    'chakkar': 'چکر',
    'clinic': 'کلینک',
    'dard': 'درد',
    'dast': 'دست',
    'dawa': 'دوا',
    'dawai': 'دوائی',
    'daktar': 'ڈاکٹر',
    'diabetes': 'ذیابیطس',
    'dil': 'دل',
    'din': 'دن',
    'doctor': 'ڈاکٹر',
    'dopahar': 'دوپہر',
    'fever': 'بخار',
    'gala': 'گلا',
    'gardan': 'گردن',
    'ghutna': 'گھٹنا',
    'goli': 'گولی',
    'haan': 'ہاں',
    'haath': 'ہاتھ',
    'han': 'ہاں',
    'hath': 'ہاتھ',
    'hay': 'ہے',
    'hai': 'ہے',
    'hain': 'ہیں',
    'hello': 'ہیلو',
    'help': 'مدد',
    'hen': 'ہیں',
    'hi': 'ہائے',
    'ho': 'ہو',
    'hoon': 'ہوں',
    'hospital': 'ہسپتال',
    'hun': 'ہوں',
    'is': 'اس',
    'jalan': 'جلن',
    'jee': 'جی',
    'ji': 'جی',
    'jism': 'جسم',
    'ka': 'کا',
    'kaan': 'کان',
    'kaisa': 'کیسا',
    'kaise': 'کیسے',
    'kal': 'کل',
    'kam': 'کم',
    'kamar': 'کمر',
    'kamzor': 'کمزور',
    'kamzori': 'کمزوری',
    'kar': 'کر',
    'karna': 'کرنا',
    'karo': 'کرو',
    'ke': 'کے',
    'kesa': 'کیسا',
    'kese': 'کیسے',
    'khana': 'کھانا',
    'khansi': 'کھانسی',
    'kharish': 'خارش',
    'khoon': 'خون',
    'khujli': 'کھجلی',
    'ki': 'کی',
    'kia': 'کیا',
    'ko': 'کو',
    'koi': 'کوئی',
    'kuch': 'کچھ',
    'kya': 'کیا',
    'kyu': 'کیوں',
    'kyun': 'کیوں',
    'lekin': 'لیکن',
    'madad': 'مدد',
    'magar': 'مگر',
    'mai': 'میں',
    'main': 'میں',
    'mareez': 'مریض',
    'medicine': 'دوا',
    'mein': 'میں',
    'mera': 'میرا',
    'mere': 'میرے',
    'meri': 'میری',
    'mujh': 'مجھ',
    'mujhay': 'مجھے',
    'mujhe': 'مجھے',
    'mujhy': 'مجھے',
    'na': 'نہ',
    'naak': 'ناک',
    'nahi': 'نہیں',
    'nahin': 'نہیں',
    'nai': 'نہیں',
    'neend': 'نیند',
    'or': 'اور',
    'paani': 'پانی',
    'pain': 'درد',
    'pair': 'پیر',
    'pait': 'پیٹ',
    'pani': 'پانی',
    'par': 'پر',
    'patient': 'مریض',
    'pe': 'پے',
    'pet': 'پیٹ',
    'please': 'براہ کرم',
    'pressure': 'پریشر',
    'raat': 'رات',
    'rash': 'خارش',
    'report': 'رپورٹ',
    'saans': 'سانس',
    'sab': 'سب',
    'sans': 'سانس',
    'sar': 'سر',
    'se': 'سے',
    'seena': 'سینہ',
    'seenay': 'سینے',
    'sehat': 'صحت',
    'shaam': 'شام',
    'shukriya': 'شکریہ',
    'sir': 'سر',
    'slot': 'وقت',
    'soojan': 'سوجن',
    'subah': 'صبح',
    'sugar': 'شوگر',
    'sujan': 'سوجن',
    'tablet': 'گولی',
    'test': 'ٹیسٹ',
    'testing': 'ٹیسٹنگ',
    'tha': 'تھا',
    'thank': 'شکریہ',
    'thanks': 'شکریہ',
    'the': 'تھے',
    'theek': 'ٹھیک',
    'thakawat': 'تھکاوٹ',
    'thakan': 'تھکاوٹ',
    'thi': 'تھی',
    'thik': 'ٹھیک',
    'time': 'وقت',
    'to': 'تو',
    'toh': 'تو',
    'tou': 'تو',
    'tum': 'تم',
    'ulti': 'الٹی',
    'us': 'اس',
    'waqt': 'وقت',
    'weak': 'کمزور',
    'wo': 'وہ',
    'woh': 'وہ',
    'ya': 'یا',
    'yah': 'یہ',
    'ye': 'یہ',
    'yeh': 'یہ',
    'you': 'یو',
    'ziada': 'زیادہ',
    'zukam': 'زکام',
    'zyada': 'زیادہ',
  };

  static const List<(String, String)> _sounds = [
    ('chh', 'چھ'),
    ('kh', 'خ'),
    ('gh', 'غ'),
    ('sh', 'ش'),
    ('ch', 'چ'),
    ('th', 'تھ'),
    ('ph', 'پھ'),
    ('bh', 'بھ'),
    ('dh', 'دھ'),
    ('jh', 'جھ'),
    ('rh', 'ڑھ'),
    ('zh', 'ژ'),
    ('aa', 'ا'),
    ('ai', 'ے'),
    ('ay', 'ے'),
    ('ei', 'ے'),
    ('au', 'و'),
    ('ou', 'و'),
    ('oo', 'و'),
    ('ee', 'ی'),
    ('ii', 'ی'),
    ('tt', 'ٹ'),
    ('dd', 'ڈ'),
    ('rr', 'ڑ'),
    ('a', 'ا'),
    ('b', 'ب'),
    ('c', 'ک'),
    ('d', 'د'),
    ('e', 'ے'),
    ('f', 'ف'),
    ('g', 'گ'),
    ('h', 'ہ'),
    ('i', 'ی'),
    ('j', 'ج'),
    ('k', 'ک'),
    ('l', 'ل'),
    ('m', 'م'),
    ('n', 'ن'),
    ('o', 'و'),
    ('p', 'پ'),
    ('q', 'ق'),
    ('r', 'ر'),
    ('s', 'س'),
    ('t', 'ت'),
    ('u', 'و'),
    ('v', 'و'),
    ('w', 'و'),
    ('x', 'کس'),
    ('y', 'ی'),
    ('z', 'ز'),
  ];

  static String toNative(String input) {
    if (input.isEmpty || !_latinWord.hasMatch(input)) return input;
    return input.replaceAllMapped(_latinWord, (match) {
      return _word(match.group(0)!);
    });
  }

  static String _word(String raw) {
    final key = raw.toLowerCase();
    final known = _words[key];
    if (known != null) return known;
    return _phonetic(key);
  }

  static String _phonetic(String word) {
    final out = StringBuffer();
    var index = 0;
    while (index < word.length) {
      if (word[index] == "'") {
        index++;
        continue;
      }
      if (index == 0 && word.startsWith('aa')) {
        out.write('آ');
        index += 2;
        continue;
      }
      if (index == 0 && word.startsWith('a')) {
        out.write('آ');
        index++;
        continue;
      }
      if (index == 0 &&
          (word.startsWith('i') ||
              word.startsWith('ee') ||
              word.startsWith('ii') ||
              word.startsWith('u') ||
              word.startsWith('oo') ||
              word.startsWith('e') ||
              word.startsWith('o'))) {
        out.write('ا');
      }
      var matched = false;
      for (final sound in _sounds) {
        if (!word.startsWith(sound.$1, index)) continue;
        out.write(sound.$2);
        index += sound.$1.length;
        matched = true;
        break;
      }
      if (!matched) index++;
    }
    return out.toString();
  }
}
