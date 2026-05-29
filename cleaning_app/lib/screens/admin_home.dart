// // screens/admin/admin_home.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../config/app_theme.dart';
// import 'admin_statistics_screen.dart';
// import 'admin_orders_screen.dart';
// import 'admin_users_screen.dart';
// import 'profile_screen.dart';

// class AdminHomeScreen extends StatefulWidget {
//   const AdminHomeScreen({super.key});

//   @override
//   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// }

// class _AdminHomeScreenState extends State<AdminHomeScreen> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           ['Статистика', 'Тапсырыстар', 'Пайдаланушылар', 'Профиль'][_currentIndex],
//           style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primary),
//         ),
//         actions: [
//           IconButton(icon: const Icon(Icons.notifications_outlined, color: AppTheme.primary), onPressed: () {}),
//         ],
//       ),
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         child: [
//           const AdminStatisticsScreen(),
//           const AdminOrdersScreen(),
//           const AdminUsersScreen(),
//           const ProfileScreen(),
//         ][_currentIndex],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (i) => setState(() => _currentIndex = i),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard_rounded), label: 'Статистика'),
//           BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long_rounded), label: 'Тапсырыстар'),
//           BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people_rounded), label: 'Пайд.'),
//           BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person_rounded), label: 'Профиль'),
//         ],
//       ),
//     );
//   }
// }

// screens/admin/admin_home.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../services/api_service.dart';
import 'admin_statistics_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_users_screen.dart';
import 'profile_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  int _unreadCount = 0;
  
  // Настоящие уведомления из API
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
    _animCtrl.forward();
    _loadUnreadCount();
    _loadNotifications();
  }

  Future<void> _loadUnreadCount() async {
    try {
      final count = await ApiService.getUnreadCount();
      if (mounted) {
        setState(() {
          _unreadCount = count;
        });
      }
    } catch (e) {
      print('Error loading unread count: $e');
    }
  }

  Future<void> _loadNotifications() async {
    try {
      // Получаем чаты/сообщения для админа
      // Здесь можно получить последние сообщения или заказы
      final orders = await ApiService.adminGetOrders();
      final users = await ApiService.adminGetUsers();
      
      // Формируем уведомления из реальных данных
      List<Map<String, dynamic>> notifications = [];
      
      // Новые заказы (pending статусы)
      final newOrders = orders.where((o) => o.status == 'pending').toList();
      if (newOrders.isNotEmpty) {
        notifications.add({
          'id': 'new_orders',
          'icon': Icons.assignment_turned_in_outlined,
          'title': 'Жаңа тапсырыстар',
          'description': '${newOrders.length} жаңа тапсырыс күтілуде',
          'time': _getTimeAgo(DateTime.now()),
          'color': const Color(0xFF4CAF50),
          'type': 'order',
        });
      }
      
      // Новые пользователи (за последние 24 часа)
      final recentUsers = users.where((u) {
        // Если есть дата регистрации, проверяем
        // Пока добавляем всех новых
        return true;
      }).toList();
      
      if (recentUsers.isNotEmpty && notifications.isEmpty) {
        notifications.add({
          'id': 'new_users',
          'icon': Icons.person_add_outlined,
          'title': 'Жаңа пайдаланушылар',
          'description': 'Жүйеге жаңа пайдаланушылар тіркелді',
          'time': 'Бүгін',
          'color': const Color(0xFF2196F3),
          'type': 'user',
        });
      }
      
      // Статистика
      final completedOrders = orders.where((o) => o.status == 'completed').length;
      if (completedOrders > 0) {
        notifications.add({
          'id': 'stats',
          'icon': Icons.insights_outlined,
          'title': 'Статистика жаңартылды',
          'description': 'Аяқталған тапсырыстар: $completedOrders',
          'time': 'Соңғы 24 сағат',
          'color': const Color(0xFFFF9800),
          'type': 'stats',
        });
      }
      
      if (mounted) {
        setState(() {
          _notifications = notifications;
        });
      }
    } catch (e) {
      print('Error loading notifications: $e');
      // Если ошибка, показываем пустой список
      if (mounted) {
        setState(() {
          _notifications = [];
        });
      }
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 1) return 'Қазір';
    if (difference.inMinutes < 60) return '${difference.inMinutes} минут бұрын';
    if (difference.inHours < 24) return '${difference.inHours} сағат бұрын';
    return '${difference.inDays} күн бұрын';
  }

  Future<void> _markAsRead(String notificationId) async {
    // Здесь можно отправить запрос на сервер для отметки прочитанного
    // Например: await ApiService.markNotificationAsRead(notificationId);
    
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
      if (_unreadCount > 0) {
        _unreadCount--;
      }
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A237E),
        title: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ['Статистика', 'Тапсырыстар', 'Пайдаланушылар', 'Профиль'][_currentIndex],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A237E),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                ['Бүгінгі көрсеткіштер', 'Барлық тапсырыстар', 'Жүйедегі пайдаланушылар', 'Жеке ақпарат'][_currentIndex],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.withAlpha(153),
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Уведомления с реальным счетчиком
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 22),
                  onPressed: () {
                    _showNotificationsDialog();
                  },
                ),
              ),
              if (_unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      _unreadCount > 9 ? '9+' : '$_unreadCount',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.withAlpha(30),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: [
          const AdminStatisticsScreen(),
          const AdminOrdersScreen(),
          const AdminUsersScreen(),
          const ProfileScreen(),
        ][_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          selectedItemColor: const Color(0xFF3949AB),
          unselectedItemColor: Colors.grey.withAlpha(153),
          selectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined, size: 24),
              activeIcon: Icon(Icons.dashboard_rounded, size: 24),
              label: 'Статистика',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined, size: 24),
              activeIcon: Icon(Icons.receipt_long_rounded, size: 24),
              label: 'Тапсырыстар',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline, size: 24),
              activeIcon: Icon(Icons.people_rounded, size: 24),
              label: 'Пайдалануш.',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              activeIcon: Icon(Icons.person_rounded, size: 24),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsDialog() async {
    // Обновляем уведомления перед показом
    await _loadNotifications();
    await _loadUnreadCount();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(51),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Хабарландырулар',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A237E),
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (_notifications.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          // Барлығын оқу функциясы
                          setStateModal(() {
                            _notifications.clear();
                            _unreadCount = 0;
                          });
                          setState(() {
                            _unreadCount = 0;
                          });
                        },
                        child: Text(
                          'Барлығын оқу',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF3949AB),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Сізге арналған соңғы жаңалықтар',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.withAlpha(153),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Настоящие уведомления из API
                if (_notifications.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.notifications_none_outlined,
                            size: 64,
                            color: Colors.grey.withAlpha(102),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Хабарландырулар жоқ',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.withAlpha(128),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._notifications.map((notification) => GestureDetector(
                    onTap: () {
                      // Уведомление басылғанда әрекет
                      _markAsRead(notification['id'].toString());
                      Navigator.pop(context);
                      
                      // Уведомление түріне байланысты бетке өту
                      switch (notification['type']) {
                        case 'order':
                          setState(() {
                            _currentIndex = 1; // Тапсырыстар беті
                          });
                          break;
                        case 'user':
                          setState(() {
                            _currentIndex = 2; // Пайдаланушылар беті
                          });
                          break;
                        case 'stats':
                          setState(() {
                            _currentIndex = 0; // Статистика беті
                          });
                          break;
                      }
                    },
                    child: _buildNotificationItem(
                      icon: notification['icon'],
                      title: notification['title'],
                      description: notification['description'],
                      time: notification['time'],
                      color: notification['color'],
                    ),
                  )),
                
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Жабу',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3949AB),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height:  8),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(30), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withAlpha(179)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.withAlpha(128),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }
}