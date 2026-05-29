// // // services/api_service.dart
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:firebase_auth/firebase_auth.dart';
// // import '../models/order_model.dart';
// // import '../models/user_model.dart';

// // class ApiService {
// //   // Өз IP мекенжайыңызды жазыңыз
// //   static const String baseUrl = 'http://192.168.1.67:3000/api'; //менять надо потом ipconfig

// //   static Future<String> _getIdToken() async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) throw Exception('Пайдаланушы жүйеге кірмеген');
// //     final token = await user.getIdToken();
// //     if (token == null) throw Exception('Токен алынбады');
// //     return token;
// //   }

// //   static Future<Map<String, String>> _authHeaders() async {
// //     final token = await _getIdToken();
// //     return {
// //       'Authorization': 'Bearer $token',
// //       'Content-Type': 'application/json',
// //     };
// //   }

// //   static Future<void> saveProfile(String name, String phone, String role) async {
// //     final headers = await _authHeaders();
// //     final res = await http.post(
// //       Uri.parse('$baseUrl/users'),
// //       headers: headers,
// //       body: jsonEncode({'name': name, 'phone': phone, 'role': role}),
// //     );
// //     if (res.statusCode != 200) {
// //       throw Exception(jsonDecode(res.body)['error'] ?? 'Белгісіз қате');
// //     }
// //   }

// //   static Future<UserModel> getProfile() async {
// //     final headers = await _authHeaders();
// //     final res = await http.get(Uri.parse('$baseUrl/users/me'), headers: headers);
// //     if (res.statusCode == 200) {
// //       return UserModel.fromJson(jsonDecode(res.body));
// //     } else {
// //       throw Exception('Профиль жүктелмеді');
// //     }
// //   }

// //   static Future<void> createOrder({
// //     required String description,
// //     required String address,
// //     String? entrance,
// //     String? comment,
// //     required String phone,
// //     required double price,
// //   }) async {
// //     final headers = await _authHeaders();
// //     final res = await http.post(
// //       Uri.parse('$baseUrl/orders'),
// //       headers: headers,
// //       body: jsonEncode({
// //         'description': description,
// //         'address': address,
// //         'entrance': entrance ?? '',
// //         'comment': comment ?? '',
// //         'phone': phone,
// //         'price': price,
// //       }),
// //     );
// //     if (res.statusCode != 200) {
// //       throw Exception(jsonDecode(res.body)['error'] ?? 'Тапсырыс жасау қатесі');
// //     }
// //   }

// //   static Future<List<OrderModel>> getClientOrders() async {
// //     final headers = await _authHeaders();
// //     final res = await http.get(Uri.parse('$baseUrl/orders/my'), headers: headers);
// //     if (res.statusCode == 200) {
// //       final List data = jsonDecode(res.body);
// //       return data.map((e) => OrderModel.fromJson(e)).toList();
// //     } else {
// //       throw Exception('Тапсырыстар жүктелмеді');
// //     }
// //   }

// //   static Future<List<OrderModel>> getAvailableOrders() async {
// //     final headers = await _authHeaders();
// //     final res = await http.get(Uri.parse('$baseUrl/orders/available'), headers: headers);
// //     if (res.statusCode == 200) {
// //       final List data = jsonDecode(res.body);
// //       return data.map((e) => OrderModel.fromJson(e)).toList();
// //     } else {
// //       throw Exception('Қолжетімді тапсырыстар жүктелмеді');
// //     }
// //   }

// //   static Future<List<OrderModel>> getAcceptedOrders() async {
// //     final headers = await _authHeaders();
// //     final res = await http.get(Uri.parse('$baseUrl/orders/accepted'), headers: headers);
// //     if (res.statusCode == 200) {
// //       final List data = jsonDecode(res.body);
// //       return data.map((e) => OrderModel.fromJson(e)).toList();
// //     } else {
// //       throw Exception('Қабылданған тапсырыстар жүктелмеді');
// //     }
// //   }

// //   static Future<void> acceptOrder(String orderId) async {
// //     final headers = await _authHeaders();
// //     final res = await http.put(
// //       Uri.parse('$baseUrl/orders/$orderId/accept'),
// //       headers: headers,
// //     );
// //     if (res.statusCode != 200) {
// //       throw Exception(jsonDecode(res.body)['error'] ?? 'Қабылдау қатесі');
// //     }
// //   }

// //   static Future<void> completeOrder(String orderId) async {
// //     final headers = await _authHeaders();
// //     final res = await http.put(
// //       Uri.parse('$baseUrl/orders/$orderId/complete'),
// //       headers: headers,
// //     );
// //     if (res.statusCode != 200) {
// //       throw Exception(jsonDecode(res.body)['error'] ?? 'Аяқтау қатесі');
// //     }
// //   }

// //   static Future<List<UserModel>> adminGetUsers() async {
// //     final headers = await _authHeaders();
// //     final res = await http.get(Uri.parse('$baseUrl/admin/users'), headers: headers);
// //     if (res.statusCode == 200) {
// //       final List data = jsonDecode(res.body);
// //       return data.map((e) => UserModel.fromJson(e)).toList();
// //     } else {
// //       throw Exception('Қолданушылар тізімі жүктелмеді');
// //     }
// //   }

// //   static Future<List<OrderModel>> adminGetOrders() async {
// //     final headers = await _authHeaders();
// //     final res = await http.get(Uri.parse('$baseUrl/admin/orders'), headers: headers);
// //     if (res.statusCode == 200) {
// //       final List data = jsonDecode(res.body);
// //       return data.map((e) => OrderModel.fromJson(e)).toList();
// //     } else {
// //       throw Exception('Тапсырыстар жүктелмеді');
// //     }
// //   }

// //   static Future<void> adminUpdateOrderStatus(String orderId, String status) async {
// //     final headers = await _authHeaders();
// //     final res = await http.put(
// //       Uri.parse('$baseUrl/admin/orders/$orderId/status'),
// //       headers: headers,
// //       body: jsonEncode({'status': status}),
// //     );
// //     if (res.statusCode != 200) {
// //       throw Exception(jsonDecode(res.body)['error'] ?? 'Статус өзгерту қатесі');
// //     }
// //   }

// //   static Future<void> adminDeleteOrder(String orderId) async {
// //     final headers = await _authHeaders();
// //     final res = await http.delete(
// //       Uri.parse('$baseUrl/admin/orders/$orderId'),
// //       headers: headers,
// //     );
// //     if (res.statusCode != 200) {
// //       throw Exception(jsonDecode(res.body)['error'] ?? 'Жою қатесі');
// //     }
// //   }
// // }
// // services/api_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/order_model.dart';
// import '../models/user_model.dart';

// class ApiService {
//   // Өз IP мекенжайыңызды жазыңыз
//   static const String baseUrl = 'http://192.168.1.67:3000/api';

//   static Future<String> _getIdToken() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception('Пайдаланушы жүйеге кірмеген');
//     final token = await user.getIdToken();
//     if (token == null) throw Exception('Токен алынбады');
//     return token;
//   }

//   static Future<Map<String, String>> _authHeaders() async {
//     final token = await _getIdToken();
//     return {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     };
//   }

//   // ==================== ПАЙДАЛАНУШЫЛАР ====================

//   static Future<void> saveProfile(String name, String phone, String role) async {
//     final headers = await _authHeaders();
//     final res = await http.post(
//       Uri.parse('$baseUrl/users'),
//       headers: headers,
//       body: jsonEncode({'name': name, 'phone': phone, 'role': role}),
//     );
//     if (res.statusCode != 200) {
//       throw Exception(jsonDecode(res.body)['error'] ?? 'Белгісіз қате');
//     }
//   }

//   static Future<UserModel> getProfile() async {
//     final headers = await _authHeaders();
//     final res = await http.get(Uri.parse('$baseUrl/users/me'), headers: headers);
//     if (res.statusCode == 200) {
//       return UserModel.fromJson(jsonDecode(res.body));
//     } else {
//       throw Exception('Профиль жүктелмеді');
//     }
//   }

//   // ==================== ТАПСЫРЫСТАР ====================

//   static Future<void> createOrder({
//     required String description,
//     required String address,
//     String? entrance,
//     String? comment,
//     required String phone,
//     required double price,
//   }) async {
//     final headers = await _authHeaders();
//     final res = await http.post(
//       Uri.parse('$baseUrl/orders'),
//       headers: headers,
//       body: jsonEncode({
//         'description': description,
//         'address': address,
//         'entrance': entrance ?? '',
//         'comment': comment ?? '',
//         'phone': phone,
//         'price': price,
//       }),
//     );
//     if (res.statusCode != 200) {
//       throw Exception(jsonDecode(res.body)['error'] ?? 'Тапсырыс жасау қатесі');
//     }
//   }

//   static Future<List<OrderModel>> getClientOrders() async {
//     final headers = await _authHeaders();
//     final res = await http.get(Uri.parse('$baseUrl/orders/my'), headers: headers);
//     if (res.statusCode == 200) {
//       final List data = jsonDecode(res.body);
//       return data.map((e) => OrderModel.fromJson(e)).toList();
//     } else {
//       throw Exception('Тапсырыстар жүктелмеді');
//     }
//   }

//   static Future<List<OrderModel>> getAvailableOrders() async {
//     final headers = await _authHeaders();
//     final res = await http.get(Uri.parse('$baseUrl/orders/available'), headers: headers);
//     if (res.statusCode == 200) {
//       final List data = jsonDecode(res.body);
//       return data.map((e) => OrderModel.fromJson(e)).toList();
//     } else {
//       throw Exception('Қолжетімді тапсырыстар жүктелмеді');
//     }
//   }

//   static Future<List<OrderModel>> getAcceptedOrders() async {
//     final headers = await _authHeaders();
//     final res = await http.get(Uri.parse('$baseUrl/orders/accepted'), headers: headers);
//     if (res.statusCode == 200) {
//       final List data = jsonDecode(res.body);
//       return data.map((e) => OrderModel.fromJson(e)).toList();
//     } else {
//       throw Exception('Қабылданған тапсырыстар жүктелмеді');
//     }
//   }

//   static Future<void> acceptOrder(String orderId) async {
//     final headers = await _authHeaders();
//     final res = await http.put(
//       Uri.parse('$baseUrl/orders/$orderId/accept'),
//       headers: headers,
//     );
//     if (res.statusCode != 200) {
//       throw Exception(jsonDecode(res.body)['error'] ?? 'Қабылдау қатесі');
//     }
//   }

//   static Future<void> completeOrder(String orderId) async {
//     final headers = await _authHeaders();
//     final res = await http.put(
//       Uri.parse('$baseUrl/orders/$orderId/complete'),
//       headers: headers,
//     );
//     if (res.statusCode != 200) {
//       throw Exception(jsonDecode(res.body)['error'] ?? 'Аяқтау қатесі');
//     }
//   }

//   // ==================== ХАБАРЛАМАЛАР (ЧАТ) ====================

//   // Тапсырыс бойынша хабарламаларды алу
//   static Future<List<Map<String, dynamic>>> getMessages(String orderId) async {
//     final headers = await _authHeaders();
//     final res = await http.get(
//       Uri.parse('$baseUrl/messages/$orderId'),
//       headers: headers,
//     );
//     if (res.statusCode == 200) {
//       final List data = jsonDecode(res.body);
//       return data.map((e) => Map<String, dynamic>.from(e)).toList();
//     }
//     return [];
//   }

//   // Хабарлама жіберу
//   static Future<void> sendMessage(String orderId, String receiverId, String text) async {
//     final headers = await _authHeaders();
//     final res = await http.post(
//       Uri.parse('$baseUrl/messages'),
//       headers: headers,
//       body: jsonEncode({
//         'orderId': orderId,
//         'receiverId': receiverId,
//         'text': text,
//       }),
//     );
//     if (res.statusCode != 200) {
//       throw Exception(jsonDecode(res.body)['error'] ?? 'Хабарлама жіберу қатесі');
//     }
//   }

//   // Оқылмаған хабарламалар саны
//   static Future<int> getUnreadCount() async {
//     final headers = await _authHeaders();
//     final res = await http.get(
//       Uri.parse('$baseUrl/messages/unread/count'),
//       headers: headers,
//     );
//     if (res.statusCode == 200) {
//       return jsonDecode(res.body)['count'] ?? 0;
//     }
//     return 0;
//   }

//   // ==================== ӘКІМШІ ====================

//   static Future<List<UserModel>> adminGetUsers() async {
//     final headers = await _authHeaders();
//     final res = await http.get(Uri.parse('$baseUrl/admin/users'), headers: headers);
//     if (res.statusCode == 200) {
//       final List data = jsonDecode(res.body);
//       return data.map((e) => UserModel.fromJson(e)).toList();
//     } else {
//       throw Exception('Қолданушылар тізімі жүктелмеді');
//     }
//   }

//   static Future<List<OrderModel>> adminGetOrders() async {
//     final headers = await _authHeaders();
//     final res = await http.get(Uri.parse('$baseUrl/admin/orders'), headers: headers);
//     if (res.statusCode == 200) {
//       final List data = jsonDecode(res.body);
//       return data.map((e) => OrderModel.fromJson(e)).toList();
//     } else {
//       throw Exception('Тапсырыстар жүктелмеді');
//     }
//   }

//   static Future<void> adminUpdateOrderStatus(String orderId, String status) async {
//     final headers = await _authHeaders();
//     final res = await http.put(
//       Uri.parse('$baseUrl/admin/orders/$orderId/status'),
//       headers: headers,
//       body: jsonEncode({'status': status}),
//     );
//     if (res.statusCode != 200) {
//       throw Exception(jsonDecode(res.body)['error'] ?? 'Статус өзгерту қатесі');
//     }
//   }

//   static Future<void> adminDeleteOrder(String orderId) async {
//     final headers = await _authHeaders();
//     final res = await http.delete(
//       Uri.parse('$baseUrl/admin/orders/$orderId'),
//       headers: headers,
//     );
//     if (res.statusCode != 200) {
//       throw Exception(jsonDecode(res.body)['error'] ?? 'Жою қатесі');
//     }
//   }
// }

// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class ApiService {
  // Chrome web үшін localhost
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<String> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Пайдаланушы жүйеге кірмеген');
    final token = await user.getIdToken();
    if (token == null) throw Exception('Токен алынбады');
    return token;
  }

  static Future<Map<String, String>> _authHeaders() async {
    final token = await _getIdToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // ==================== ПАЙДАЛАНУШЫЛАР ====================

  static Future<void> saveProfile(String name, String phone, String role) async {
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: headers,
      body: jsonEncode({'name': name, 'phone': phone, 'role': role}),
    );
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Белгісіз қате');
    }
  }

  static Future<UserModel> getProfile() async {
    final headers = await _authHeaders();
    final res = await http.get(Uri.parse('$baseUrl/users/me'), headers: headers);
    if (res.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Профиль жүктелмеді');
    }
  }

  // ==================== ТАПСЫРЫСТАР ====================

  static Future<void> createOrder({
    required String description,
    required String address,
    String? entrance,
    String? comment,
    required String phone,
    required double price,
  }) async {
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: headers,
      body: jsonEncode({
        'description': description,
        'address': address,
        'entrance': entrance ?? '',
        'comment': comment ?? '',
        'phone': phone,
        'price': price,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Тапсырыс жасау қатесі');
    }
  }

  static Future<List<OrderModel>> getClientOrders() async {
    final headers = await _authHeaders();
    final res = await http.get(Uri.parse('$baseUrl/orders/my'), headers: headers);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception('Тапсырыстар жүктелмеді');
    }
  }

  static Future<List<OrderModel>> getAvailableOrders() async {
    final headers = await _authHeaders();
    final res = await http.get(Uri.parse('$baseUrl/orders/available'), headers: headers);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception('Қолжетімді тапсырыстар жүктелмеді');
    }
  }

  static Future<List<OrderModel>> getAcceptedOrders() async {
    final headers = await _authHeaders();
    final res = await http.get(Uri.parse('$baseUrl/orders/accepted'), headers: headers);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception('Қабылданған тапсырыстар жүктелмеді');
    }
  }

  static Future<void> acceptOrder(String orderId) async {
    final headers = await _authHeaders();
    final res = await http.put(
      Uri.parse('$baseUrl/orders/$orderId/accept'),
      headers: headers,
    );
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Қабылдау қатесі');
    }
  }

  static Future<void> completeOrder(String orderId) async {
    final headers = await _authHeaders();
    final res = await http.put(
      Uri.parse('$baseUrl/orders/$orderId/complete'),
      headers: headers,
    );
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Аяқтау қатесі');
    }
  }

  // ==================== ХАБАРЛАМАЛАР (ЧАТ) ====================

  static Future<List<Map<String, dynamic>>> getMessages(String orderId) async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse('$baseUrl/messages/$orderId'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  static Future<void> sendMessage(String orderId, String receiverId, String text) async {
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: headers,
      body: jsonEncode({
        'orderId': orderId,
        'receiverId': receiverId,
        'text': text,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Хабарлама жіберу қатесі');
    }
  }

  static Future<int> getUnreadCount() async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse('$baseUrl/messages/unread/count'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['count'] ?? 0;
    }
    return 0;
  }



  // api_service.dart файлына қосыңыз:

// Хабарландыруларды оқу
static Future<void> markNotificationAsRead(String notificationId) async {
  final headers = await _authHeaders();
  final res = await http.put(
    Uri.parse('$baseUrl/notifications/$notificationId/read'),
    headers: headers,
  );
  if (res.statusCode != 200) {
    throw Exception(jsonDecode(res.body)['error'] ?? 'Хабарландыруды оқу қатесі');
  }
}

// Барлық хабарландыруларды оқу
static Future<void> markAllNotificationsAsRead() async {
  final headers = await _authHeaders();
  final res = await http.put(
    Uri.parse('$baseUrl/notifications/read-all'),
    headers: headers,
  );
  if (res.statusCode != 200) {
    throw Exception('Хабарландыруларды оқу қатесі');
  }
}

// Хабарландырулар тізімін алу
static Future<List<Map<String, dynamic>>> getNotifications() async {
  final headers = await _authHeaders();
  final res = await http.get(
    Uri.parse('$baseUrl/notifications'),
    headers: headers,
  );
  if (res.statusCode == 200) {
    final List data = jsonDecode(res.body);
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }
  return [];
}
  // ==================== ӘКІМШІ ====================

  static Future<List<UserModel>> adminGetUsers() async {
    final headers = await _authHeaders();
    final res = await http.get(Uri.parse('$baseUrl/admin/users'), headers: headers);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Қолданушылар тізімі жүктелмеді');
    }
  }

  static Future<List<OrderModel>> adminGetOrders() async {
    final headers = await _authHeaders();
    final res = await http.get(Uri.parse('$baseUrl/admin/orders'), headers: headers);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception('Тапсырыстар жүктелмеді');
    }
  }

  static Future<void> adminUpdateOrderStatus(String orderId, String status) async {
    final headers = await _authHeaders();
    final res = await http.put(
      Uri.parse('$baseUrl/admin/orders/$orderId/status'),
      headers: headers,
      body: jsonEncode({'status': status}),
    );
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Статус өзгерту қатесі');
    }
  }

  static Future<void> adminDeleteOrder(String orderId) async {
    final headers = await _authHeaders();
    final res = await http.delete(
      Uri.parse('$baseUrl/admin/orders/$orderId'),
      headers: headers,
    );
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Жою қатесі');
    }
  }
}