// // config/app_constants.dart
// import 'package:flutter/material.dart';

// class AppConstants {
//   static const List<Map<String, dynamic>> cleaningTypes = [
//     {
//       'id': 'general',
//       'name': 'Генералды тазалау',
//       'icon': '🧹',
//       'basePrice': 15000,
//       'duration': '3-4 сағат',
//     },
//     {
//       'id': 'windows',
//       'name': 'Терезе жуу',
//       'icon': '🪟',
//       'basePrice': 8000,
//       'duration': '1-2 сағат',
//     },
//     {
//       'id': 'furniture',
//       'name': 'Жиһаз тазалау',
//       'icon': '🛋️',
//       'basePrice': 10000,
//       'duration': '2-3 сағат',
//     },
//     {
//       'id': 'carpet',
//       'name': 'Кілем тазалау',
//       'icon': '🟫',
//       'basePrice': 12000,
//       'duration': '1-2 сағат',
//     },
//     {
//       'id': 'office',
//       'name': 'Офис тазалау',
//       'icon': '🏢',
//       'basePrice': 20000,
//       'duration': '4-6 сағат',
//     },
//     {
//       'id': 'after_repair',
//       'name': 'Жөндеуден кейін',
//       'icon': '🔧',
//       'basePrice': 25000,
//       'duration': '5-8 сағат',
//     },
//   ];

//   static const List<String> roomTypes = [
//     '1 бөлмелі',
//     '2 бөлмелі',
//     '3 бөлмелі',
//     '4+ бөлмелі',
//     'Офис',
//     'Үй',
//     'Коттедж',
//   ];

//   static final Map<String, Color> statusColors = {
//     'pending': const Color(0xFFFFA502),
//     'accepted': const Color(0xFF1E90FF),
//     'in_progress': const Color(0xFF9B59B6),
//     'completed': const Color(0xFF2ED573),
//     'cancelled': const Color(0xFFFF4757),
//   };

//   static final Map<String, String> statusNames = {
//     'pending': 'Күтілуде',
//     'accepted': 'Қабылданды',
//     'in_progress': 'Орындалуда',
//     'completed': 'Аяқталды',
//     'cancelled': 'Бас тартылды',
//   };
// }

// config/app_constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  // Клининг түрлері (кеңейтілген)
  static const List<Map<String, dynamic>> cleaningTypes = [
    {
      'id': 'general',
      'name': 'Генералды тазалау',
      'icon': '🧹',
      'iconData': Icons.cleaning_services,
      'basePrice': 15000,
      'duration': '3-4 сағат',
      'description': 'Толық үй/пәтер тазалау. Шаңсорғыш, ылғалды тазалау, жуу.',
      'popularity': 5,
    },
    {
      'id': 'windows',
      'name': 'Терезе жуу',
      'icon': '🪟',
      'iconData': Icons.window,
      'basePrice': 8000,
      'duration': '1-2 сағат',
      'description': 'Терезелерді кәсіби жуу, жақтауларды тазалау.',
      'popularity': 4,
    },
    {
      'id': 'furniture',
      'name': 'Жиһаз тазалау',
      'icon': '🛋️',
      'iconData': Icons.weekend,
      'basePrice': 10000,
      'duration': '2-3 сағат',
      'description': 'Жұмсақ жиһазды терең тазалау, дақтарды кетіру.',
      'popularity': 4,
    },
    {
      'id': 'carpet',
      'name': 'Кілем тазалау',
      'icon': '🟫',
      'iconData': Icons.carpenter,
      'basePrice': 12000,
      'duration': '1-2 сағат',
      'description': 'Кілемдерді химиялық тазалау, дақтарды кетіру.',
      'popularity': 3,
    },
    {
      'id': 'office',
      'name': 'Офис тазалау',
      'icon': '🏢',
      'iconData': Icons.business_center,
      'basePrice': 20000,
      'duration': '4-6 сағат',
      'description': 'Кеңсе/офис үй-жайларын кәсіби тазалау.',
      'popularity': 5,
    },
    {
      'id': 'after_repair',
      'name': 'Жөндеуден кейін',
      'icon': '🔧',
      'iconData': Icons.build,
      'basePrice': 25000,
      'duration': '5-8 сағат',
      'description': 'Құрылыс шаңынан, қалдықтардан тазалау.',
      'popularity': 4,
    },
    {
      'id': 'kitchen',
      'name': 'Ас үй тазалау',
      'icon': '🍳',
      'iconData': Icons.kitchen,
      'basePrice': 12000,
      'duration': '2-3 сағат',
      'description': 'Пеш, духовка, сорғыш, жуғышты терең тазалау.',
      'popularity': 5,
    },
    {
      'id': 'bathroom',
      'name': 'Жуынатын бөлме',
      'icon': '🚿',
      'iconData': Icons.bathtub,
      'basePrice': 10000,
      'duration': '1-2 сағат',
      'description': 'Ванна, душ, унитаз, плитканы тазалау.',
      'popularity': 5,
    },
    {
      'id': 'express',
      'name': 'Экспресс тазалау',
      'icon': '⚡',
      'iconData': Icons.flash_on,
      'basePrice': 7000,
      'duration': '1 сағат',
      'description': 'Жедел беттік тазалау. Шаңсорғыш, шаң сүрту.',
      'popularity': 4,
    },
  ];

  // Бөлме түрлері (кеңейтілген)
  static const List<String> roomTypes = [
    '1 бөлмелі пәтер',
    '2 бөлмелі пәтер',
    '3 бөлмелі пәтер',
    '4+ бөлмелі пәтер',
    'Студия',
    'Офис/Кеңсе',
    'Жеке үй',
    'Коттедж',
    'Дүкен/Салон',
    'Ресторан/Кафе',
  ];

  // Статус түстері
  static const Map<String, Color> statusColors = {
    'pending': Color(0xFFFF9800),   // Қызғылт сары
    'accepted': Color(0xFF2196F3),  // Көк
    'in_progress': Color(0xFF9C27B0), // Күлгін
    'completed': Color(0xFF4CAF50),  // Жасыл
    'cancelled': Color(0xFFF44336),  // Қызыл
  };

  // Статус атаулары
  static const Map<String, String> statusNames = {
    'pending': 'Күтілуде',
    'accepted': 'Қабылданды',
    'in_progress': 'Орындалуда',
    'completed': 'Аяқталды',
    'cancelled': 'Бас тартылды',
  };

  // Статус иконкалары
  static const Map<String, IconData> statusIcons = {
    'pending': Icons.pending_outlined,
    'accepted': Icons.check_circle_outline,
    'in_progress': Icons.hourglass_empty_outlined,
    'completed': Icons.done_all_outlined,
    'cancelled': Icons.cancel_outlined,
  };

  // Рөл түстері
  static const Map<String, Color> roleColors = {
    'admin': Color(0xFFF44336),   // Қызыл
    'cleaner': Color(0xFF4CAF50), // Жасыл
    'client': Color(0xFF2196F3),  // Көк
  };

  // Рөл атаулары
  static const Map<String, String> roleNames = {
    'admin': 'Әкімші',
    'cleaner': 'Клинер',
    'client': 'Клиент',
  };

  // Рөл иконкалары
  static const Map<String, IconData> roleIcons = {
    'admin': Icons.admin_panel_settings,
    'cleaner': Icons.cleaning_services,
    'client': Icons.person,
  };

  // Уақыт кестесі (сағат)
  static const List<String> timeSlots = [
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
    '16:00 - 17:00',
    '17:00 - 18:00',
  ];

  // Қосымша қызметтер
  static const List<Map<String, dynamic>> extraServices = [
    {'name': 'Терезе жуу (ішкі)', 'price': 5000, 'icon': '🪟'},
    {'name': 'Терезе жуу (сыртқы)', 'price': 8000, 'icon': '🏠'},
    {'name': 'Тоңазытқыш жуу', 'price': 3000, 'icon': '🧊'},
    {'name': 'Пеш/Духовка тазалау', 'price': 4000, 'icon': '🔥'},
    {'name': 'Кір жуу/Үтіктеу', 'price': 5000, 'icon': '👕'},
    {'name': 'Балкон/Лоджия', 'price': 3000, 'icon': '🌿'},
  ];

  // Төлем әдістері
  static const List<Map<String, dynamic>> paymentMethods = [
    {'id': 'cash', 'name': 'Қолма-қол ақша', 'icon': Icons.money, 'color': Color(0xFF4CAF50)},
    {'id': 'card', 'name': 'Банк картасы', 'icon': Icons.credit_card, 'color': Color(0xFF2196F3)},
    {'id': 'kaspi', 'name': 'Kaspi QR', 'icon': Icons.qr_code, 'color': Color(0xFFE31E24)},
  ];

  // Акциялар
  static const List<Map<String, dynamic>> promotions = [
    {
      'id': 'first_order',
      'title': 'Бірінші тапсырыс',
      'description': 'Алғашқы тапсырысқа 10% жеңілдік',
      'discount': 10,
      'color': Color(0xFFFF9800),
    },
    {
      'id': 'weekly',
      'title': 'Апталық тазалау',
      'description': 'Аптасына 3+ тазалау → 15% жеңілдік',
      'discount': 15,
      'color': Color(0xFF4CAF50),
    },
    {
      'id': 'referral',
      'title': 'Досыңды шақыр',
      'description': 'Досың шақырған тапсырыстан 5000₸',
      'discount': 5000,
      'color': Color(0xFF2196F3),
    },
  ];

  // Бағалар (коэффициенттер)
  static const Map<String, double> priceCoefficients = {
    '1 бөлмелі': 1.0,
    '2 бөлмелі': 1.2,
    '3 бөлмелі': 1.4,
    '4+ бөлмелі': 1.6,
    'Студия': 0.9,
    'Офис/Кеңсе': 1.3,
    'Жеке үй': 1.5,
    'Коттедж': 1.8,
  };

  // Анимация ұзақтықтары
  static const Duration animDurationFast = Duration(milliseconds: 200);
  static const Duration animDurationNormal = Duration(milliseconds: 400);
  static const Duration animDurationSlow = Duration(milliseconds: 600);
  static const Duration animDurationVerySlow = Duration(milliseconds: 800);

  // Форматтар
  static const String dateFormat = 'dd.MM.yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd.MM.yyyy HH:mm';

  // Хабарлама шаблондары
  static const Map<String, String> notificationTemplates = {
    'order_created': 'Жаңа тапсырыс #%s жасалды',
    'order_accepted': 'Тапсырыс #%s қабылданды',
    'order_completed': 'Тапсырыс #%s аяқталды',
    'order_cancelled': 'Тапсырыс #%s бас тартылды',
    'new_message': 'Сізге жаңа хабарлама келді',
    'payment_received': 'Төлем түсті: %s ₸',
  };

  // Қолдау байланысы
  static const String supportPhone = '+7 (700) 000-00-00';
  static const String supportEmail = 'support@cleanpro.kz';
  static const String supportTelegram = '@cleanpro_support';
  static const String supportWhatsApp = '+7 700 000 0000';
}