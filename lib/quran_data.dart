// lib/quran_data.dart

class QuranData {
  static const int totalPages = 604;

  /// All 114 Surahs of the Holy Quran
  /// Format: {name, arabic, startPage, pages}
  static const List<Map<String, dynamic>> surahs = [
    {'name': 'Al-Fatihah', 'arabic': 'الفاتحة', 'startPage': 1, 'pages': '1'},
    {'name': 'Al-Baqarah', 'arabic': 'البقرة', 'startPage': 2, 'pages': '2-49'},
    {
      'name': 'Ali \'Imran',
      'arabic': 'آل عمران',
      'startPage': 50,
      'pages': '50-76'
    },
    {'name': 'An-Nisa', 'arabic': 'النساء', 'startPage': 77, 'pages': '77-106'},
    {
      'name': 'Al-Ma\'idah',
      'arabic': 'المائدة',
      'startPage': 106,
      'pages': '106-127'
    },
    {
      'name': 'Al-An\'am',
      'arabic': 'الأنعام',
      'startPage': 128,
      'pages': '128-150'
    },
    {
      'name': 'Al-A\'raf',
      'arabic': 'الأعراف',
      'startPage': 151,
      'pages': '151-176'
    },
    {
      'name': 'Al-Anfal',
      'arabic': 'الأنفال',
      'startPage': 177,
      'pages': '177-186'
    },
    {
      'name': 'At-Tawbah',
      'arabic': 'التوبة',
      'startPage': 187,
      'pages': '187-207'
    },
    {'name': 'Yunus', 'arabic': 'يونس', 'startPage': 208, 'pages': '208-221'},
    {'name': 'Hud', 'arabic': 'هود', 'startPage': 221, 'pages': '221-235'},
    {'name': 'Yusuf', 'arabic': 'يوسف', 'startPage': 235, 'pages': '235-248'},
    {
      'name': 'Ar-Ra\'d',
      'arabic': 'الرعد',
      'startPage': 249,
      'pages': '249-255'
    },
    {
      'name': 'Ibrahim',
      'arabic': 'إبراهيم',
      'startPage': 255,
      'pages': '255-261'
    },
    {
      'name': 'Al-Hijr',
      'arabic': 'الحجر',
      'startPage': 262,
      'pages': '262-267'
    },
    {
      'name': 'An-Nahl',
      'arabic': 'النحل',
      'startPage': 267,
      'pages': '267-281'
    },
    {
      'name': 'Al-Isra',
      'arabic': 'الإسراء',
      'startPage': 282,
      'pages': '282-293'
    },
    {
      'name': 'Al-Kahf',
      'arabic': 'الكهف',
      'startPage': 293,
      'pages': '293-304'
    },
    {'name': 'Maryam', 'arabic': 'مريم', 'startPage': 305, 'pages': '305-312'},
    {'name': 'Ta-Ha', 'arabic': 'طه', 'startPage': 312, 'pages': '312-321'},
    {
      'name': 'Al-Anbiya',
      'arabic': 'الأنبياء',
      'startPage': 322,
      'pages': '322-331'
    },
    {'name': 'Al-Hajj', 'arabic': 'الحج', 'startPage': 332, 'pages': '332-341'},
    {
      'name': 'Al-Mu\'minun',
      'arabic': 'المؤمنون',
      'startPage': 342,
      'pages': '342-349'
    },
    {'name': 'An-Nur', 'arabic': 'النور', 'startPage': 350, 'pages': '350-359'},
    {
      'name': 'Al-Furqan',
      'arabic': 'الفرقان',
      'startPage': 359,
      'pages': '359-366'
    },
    {
      'name': 'Ash-Shu\'ara',
      'arabic': 'الشعراء',
      'startPage': 367,
      'pages': '367-376'
    },
    {
      'name': 'An-Naml',
      'arabic': 'النمل',
      'startPage': 377,
      'pages': '377-385'
    },
    {
      'name': 'Al-Qasas',
      'arabic': 'القصص',
      'startPage': 385,
      'pages': '385-396'
    },
    {
      'name': 'Al-Ankabut',
      'arabic': 'العنكبوت',
      'startPage': 396,
      'pages': '396-404'
    },
    {'name': 'Ar-Rum', 'arabic': 'الروم', 'startPage': 404, 'pages': '404-410'},
    {'name': 'Luqman', 'arabic': 'لقمان', 'startPage': 411, 'pages': '411-414'},
    {
      'name': 'As-Sajdah',
      'arabic': 'السجدة',
      'startPage': 415,
      'pages': '415-417'
    },
    {
      'name': 'Al-Ahzab',
      'arabic': 'الأحزاب',
      'startPage': 418,
      'pages': '418-427'
    },
    {'name': 'Saba', 'arabic': 'سبأ', 'startPage': 428, 'pages': '428-434'},
    {'name': 'Fatir', 'arabic': 'فاطر', 'startPage': 434, 'pages': '434-440'},
    {'name': 'Ya-Sin', 'arabic': 'يس', 'startPage': 440, 'pages': '440-445'},
    {
      'name': 'As-Saffat',
      'arabic': 'الصافات',
      'startPage': 446,
      'pages': '446-452'
    },
    {'name': 'Sad', 'arabic': 'ص', 'startPage': 453, 'pages': '453-458'},
    {
      'name': 'Az-Zumar',
      'arabic': 'الزمر',
      'startPage': 458,
      'pages': '458-467'
    },
    {'name': 'Ghafir', 'arabic': 'غافر', 'startPage': 467, 'pages': '467-476'},
    {
      'name': 'Fussilat',
      'arabic': 'فصلت',
      'startPage': 477,
      'pages': '477-482'
    },
    {
      'name': 'Ash-Shura',
      'arabic': 'الشورى',
      'startPage': 483,
      'pages': '483-489'
    },
    {
      'name': 'Az-Zukhruf',
      'arabic': 'الزخرف',
      'startPage': 489,
      'pages': '489-495'
    },
    {
      'name': 'Ad-Dukhan',
      'arabic': 'الدخان',
      'startPage': 496,
      'pages': '496-498'
    },
    {
      'name': 'Al-Jathiyah',
      'arabic': 'الجاثية',
      'startPage': 499,
      'pages': '499-502'
    },
    {
      'name': 'Al-Ahqaf',
      'arabic': 'الأحقاف',
      'startPage': 502,
      'pages': '502-506'
    },
    {
      'name': 'Muhammad',
      'arabic': 'محمد',
      'startPage': 507,
      'pages': '507-510'
    },
    {
      'name': 'Al-Fath',
      'arabic': 'الفتح',
      'startPage': 511,
      'pages': '511-515'
    },
    {
      'name': 'Al-Hujurat',
      'arabic': 'الحجرات',
      'startPage': 515,
      'pages': '515-517'
    },
    {'name': 'Qaf', 'arabic': 'ق', 'startPage': 518, 'pages': '518-520'},
    {
      'name': 'Adh-Dhariyat',
      'arabic': 'الذاريات',
      'startPage': 520,
      'pages': '520-523'
    },
    {'name': 'At-Tur', 'arabic': 'الطور', 'startPage': 523, 'pages': '523-525'},
    {
      'name': 'An-Najm',
      'arabic': 'النجم',
      'startPage': 526,
      'pages': '526-528'
    },
    {
      'name': 'Al-Qamar',
      'arabic': 'القمر',
      'startPage': 528,
      'pages': '528-531'
    },
    {
      'name': 'Ar-Rahman',
      'arabic': 'الرحمن',
      'startPage': 531,
      'pages': '531-534'
    },
    {
      'name': 'Al-Waqi\'ah',
      'arabic': 'الواقعة',
      'startPage': 534,
      'pages': '534-537'
    },
    {
      'name': 'Al-Hadid',
      'arabic': 'الحديد',
      'startPage': 537,
      'pages': '537-541'
    },
    {
      'name': 'Al-Mujadila',
      'arabic': 'المجادلة',
      'startPage': 542,
      'pages': '542-545'
    },
    {
      'name': 'Al-Hashr',
      'arabic': 'الحشر',
      'startPage': 545,
      'pages': '545-548'
    },
    {
      'name': 'Al-Mumtahanah',
      'arabic': 'الممتحنة',
      'startPage': 549,
      'pages': '549-551'
    },
    {'name': 'As-Saff', 'arabic': 'الصف', 'startPage': 551, 'pages': '551-552'},
    {
      'name': 'Al-Jumu\'ah',
      'arabic': 'الجمعة',
      'startPage': 553,
      'pages': '553-554'
    },
    {
      'name': 'Al-Munafiqun',
      'arabic': 'المنافقون',
      'startPage': 554,
      'pages': '554-555'
    },
    {
      'name': 'At-Taghabun',
      'arabic': 'التغابن',
      'startPage': 556,
      'pages': '556-557'
    },
    {
      'name': 'At-Talaq',
      'arabic': 'الطلاق',
      'startPage': 558,
      'pages': '558-559'
    },
    {
      'name': 'At-Tahrim',
      'arabic': 'التحريم',
      'startPage': 560,
      'pages': '560-561'
    },
    {
      'name': 'Al-Mulk',
      'arabic': 'الملك',
      'startPage': 562,
      'pages': '562-564'
    },
    {
      'name': 'Al-Qalam',
      'arabic': 'القلم',
      'startPage': 564,
      'pages': '564-566'
    },
    {
      'name': 'Al-Haqqah',
      'arabic': 'الحاقة',
      'startPage': 566,
      'pages': '566-568'
    },
    {
      'name': 'Al-Ma\'arij',
      'arabic': 'المعارج',
      'startPage': 568,
      'pages': '568-570'
    },
    {'name': 'Nuh', 'arabic': 'نوح', 'startPage': 570, 'pages': '570-571'},
    {'name': 'Al-Jinn', 'arabic': 'الجن', 'startPage': 572, 'pages': '572-573'},
    {
      'name': 'Al-Muzzammil',
      'arabic': 'المزمل',
      'startPage': 574,
      'pages': '574-575'
    },
    {
      'name': 'Al-Muddaththir',
      'arabic': 'المدثر',
      'startPage': 575,
      'pages': '575-577'
    },
    {
      'name': 'Al-Qiyamah',
      'arabic': 'القيامة',
      'startPage': 577,
      'pages': '577-578'
    },
    {
      'name': 'Al-Insan',
      'arabic': 'الإنسان',
      'startPage': 578,
      'pages': '578-580'
    },
    {
      'name': 'Al-Mursalat',
      'arabic': 'المرسلات',
      'startPage': 580,
      'pages': '580-581'
    },
    {
      'name': 'An-Naba',
      'arabic': 'النبأ',
      'startPage': 582,
      'pages': '582-583'
    },
    {
      'name': 'An-Nazi\'at',
      'arabic': 'النازعات',
      'startPage': 583,
      'pages': '583-584'
    },
    {'name': 'Abasa', 'arabic': 'عبس', 'startPage': 585, 'pages': '585-586'},
    {
      'name': 'At-Takwir',
      'arabic': 'التكوير',
      'startPage': 586,
      'pages': '586-587'
    },
    {
      'name': 'Al-Infitar',
      'arabic': 'الانفطار',
      'startPage': 587,
      'pages': '587-588'
    },
    {
      'name': 'Al-Mutaffifin',
      'arabic': 'المطففين',
      'startPage': 587,
      'pages': '587-589'
    },
    {
      'name': 'Al-Inshiqaq',
      'arabic': 'الانشقاق',
      'startPage': 589,
      'pages': '589-590'
    },
    {
      'name': 'Al-Buruj',
      'arabic': 'البروج',
      'startPage': 590,
      'pages': '590-591'
    },
    {
      'name': 'At-Tariq',
      'arabic': 'الطارق',
      'startPage': 591,
      'pages': '591-592'
    },
    {
      'name': 'Al-A\'la',
      'arabic': 'الأعلى',
      'startPage': 591,
      'pages': '591-592'
    },
    {
      'name': 'Al-Ghashiyah',
      'arabic': 'الغاشية',
      'startPage': 592,
      'pages': '592-593'
    },
    {
      'name': 'Al-Fajr',
      'arabic': 'الفجر',
      'startPage': 593,
      'pages': '593-594'
    },
    {
      'name': 'Al-Balad',
      'arabic': 'البلد',
      'startPage': 594,
      'pages': '594-595'
    },
    {'name': 'Ash-Shams', 'arabic': 'الشمس', 'startPage': 595, 'pages': '595'},
    {
      'name': 'Al-Layl',
      'arabic': 'الليل',
      'startPage': 595,
      'pages': '595-596'
    },
    {'name': 'Ad-Duha', 'arabic': 'الضحى', 'startPage': 596, 'pages': '596'},
    {
      'name': 'Ash-Sharh',
      'arabic': 'الشرح',
      'startPage': 596,
      'pages': '596-597'
    },
    {'name': 'At-Tin', 'arabic': 'التين', 'startPage': 597, 'pages': '597'},
    {
      'name': 'Al-Alaq',
      'arabic': 'العلق',
      'startPage': 597,
      'pages': '597-598'
    },
    {'name': 'Al-Qadr', 'arabic': 'القدر', 'startPage': 598, 'pages': '598'},
    {
      'name': 'Al-Bayyinah',
      'arabic': 'البينة',
      'startPage': 598,
      'pages': '598-599'
    },
    {
      'name': 'Az-Zalzalah',
      'arabic': 'الزلزلة',
      'startPage': 599,
      'pages': '599'
    },
    {
      'name': 'Al-Adiyat',
      'arabic': 'العاديات',
      'startPage': 599,
      'pages': '599-600'
    },
    {
      'name': 'Al-Qari\'ah',
      'arabic': 'القارعة',
      'startPage': 600,
      'pages': '600'
    },
    {
      'name': 'At-Takathur',
      'arabic': 'التكاثر',
      'startPage': 600,
      'pages': '600-601'
    },
    {'name': 'Al-Asr', 'arabic': 'العصر', 'startPage': 601, 'pages': '601'},
    {
      'name': 'Al-Humazah',
      'arabic': 'الهمزة',
      'startPage': 601,
      'pages': '601-602'
    },
    {'name': 'Al-Fil', 'arabic': 'الفيل', 'startPage': 602, 'pages': '602'},
    {'name': 'Quraysh', 'arabic': 'قريش', 'startPage': 602, 'pages': '602-603'},
    {
      'name': 'Al-Ma\'un',
      'arabic': 'الماعون',
      'startPage': 603,
      'pages': '603'
    },
    {
      'name': 'Al-Kawthar',
      'arabic': 'الكوثر',
      'startPage': 603,
      'pages': '603'
    },
    {
      'name': 'Al-Kafirun',
      'arabic': 'الكافرون',
      'startPage': 603,
      'pages': '603-604'
    },
    {'name': 'An-Nasr', 'arabic': 'النصر', 'startPage': 604, 'pages': '604'},
    {
      'name': 'Al-Masad',
      'arabic': 'المسد',
      'startPage': 604,
      'pages': '604-605'
    },
    {
      'name': 'Al-Ikhlas',
      'arabic': 'الإخلاص',
      'startPage': 604,
      'pages': '604-605'
    },
    {'name': 'Al-Falaq', 'arabic': 'الفلق', 'startPage': 605, 'pages': '605'},
    {'name': 'An-Nas', 'arabic': 'الناس', 'startPage': 605, 'pages': '605-606'},
  ];

  /// Find the Surah that contains a given page number
  static Map<String, dynamic> surahForPage(int page) {
    Map<String, dynamic> result = surahs.first;
    for (final s in surahs) {
      if ((s['startPage'] as int) <= page) {
        result = s;
      } else {
        break;
      }
    }
    return result;
  }

  /// Get the path to a page image
  /// Images must be named page001.png through page604.png
  static String pagePath(int pageNumber) {
    return 'assets/quranpages/page${pageNumber.toString().padLeft(3, '0')}.png';
  }

  /// Get all bookmark pages inside a given Surah
  static List<int> getSurahPageRange(int index) {
    if (index < 0 || index >= surahs.length) return [];
    final startPage = surahs[index]['startPage'] as int;
    final endPage = (index < surahs.length - 1)
        ? (surahs[index + 1]['startPage'] as int) - 1
        : totalPages;
    return List.generate(endPage - startPage + 1, (i) => startPage + i);
  }
}
