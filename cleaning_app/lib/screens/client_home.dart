// // // screens/client_home.dart
// // import 'package:flutter/material.dart';
// // import 'my_orders_screen.dart';
// // import 'create_order_screen.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'login_screen.dart';

// // class ClientHomeScreen extends StatefulWidget {
// //   const ClientHomeScreen({super.key});

// //   @override
// //   State<ClientHomeScreen> createState() => _ClientHomeScreenState();
// // }

// // class _ClientHomeScreenState extends State<ClientHomeScreen> {
// //   int _currentIndex = 0;
// //   final _screens = [
// //     MyOrdersScreen(),
// //     CreateOrderScreen(),
// //   ];

// //   Future<void> _logout() async {
// //     await FirebaseAuth.instance.signOut();
// //     Navigator.pushAndRemoveUntil(
// //       context,
// //       MaterialPageRoute(builder: (_) => LoginScreen()),
// //       (route) => false,
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Клиент'),
// //         actions: [
// //           IconButton(icon: Icon(Icons.logout), onPressed: _logout),
// //         ],
// //       ),
// //       body: _screens[_currentIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _currentIndex,
// //         backgroundColor: Color(0xFF1E1E1E),
// //         selectedItemColor: Color(0xFFFFD700),
// //         unselectedItemColor: Colors.white60,
// //         onTap: (i) => setState(() => _currentIndex = i),
// //         items: [
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.list_alt),
// //             label: 'Менің тапсырыстарым',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.add_circle_outline),
// //             label: 'Жаңа тапсырыс',
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }











// // // screens/client_home.dart
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import '../config/app_theme.dart';
// // import 'my_orders_screen.dart';
// // import 'create_order_screen.dart';
// // import 'chat_list_screen.dart';
// // import 'profile_screen.dart';

// // class ClientHomeScreen extends StatefulWidget {
// //   const ClientHomeScreen({super.key});

// //   @override
// //   State<ClientHomeScreen> createState() => _ClientHomeScreenState();
// // }

// // class _ClientHomeScreenState extends State<ClientHomeScreen> {
// //   int _currentIndex = 0;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           ['Тапсырыстар', 'Жаңа', 'Чат', 'Профиль'][_currentIndex],
// //           style: GoogleFonts.montserrat(
// //             fontSize: 20,
// //             fontWeight: FontWeight.w700,
// //             color: Colors.white,
// //           ),
// //         ),
// //       ),
// //       body: AnimatedSwitcher(
// //         duration: const Duration(milliseconds: 300),
// //         child: [
// //           const MyOrdersScreen(),
// //           const CreateOrderScreen(),
// //           const ChatListScreen(userRole: 'client'),
// //           const ProfileScreen(),
// //         ][_currentIndex],
// //       ),
// //       bottomNavigationBar: Container(
// //         decoration: BoxDecoration(
// //           border: Border(top: BorderSide(color: Colors.white.withAlpha(10))),
// //         ),
// //         child: BottomNavigationBar(
// //           currentIndex: _currentIndex,
// //           onTap: (i) => setState(() => _currentIndex = i),
// //           items: const [
// //             BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Тапсырыстар'),
// //             BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), activeIcon: Icon(Icons.add_circle), label: 'Жаңа'),
// //             BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), activeIcon: Icon(Icons.chat), label: 'Чат'),
// //             BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Профиль'),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }





// // screens/client/client_home.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../config/app_theme.dart';
// import 'my_orders_screen.dart';
// import 'create_order_screen.dart';
// import 'chat_list_screen.dart';
// import 'profile_screen.dart';

// class ClientHomeScreen extends StatefulWidget {
//   const ClientHomeScreen({super.key});

//   @override
//   State<ClientHomeScreen> createState() => _ClientHomeScreenState();
// }

// class _ClientHomeScreenState extends State<ClientHomeScreen> with SingleTickerProviderStateMixin {
//   int _currentIndex = 0;
//   late AnimationController _animCtrl;
//   late Animation<double> _fadeAnim;

//   final _screens = const [
//     MyOrdersScreen(),
//     CreateOrderScreen(),
//     ChatListScreen(userRole: 'client'),
//     ProfileScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
//     _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
//     _animCtrl.forward();
//   }

//   @override
//   void dispose() {
//     _animCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF1A237E),
//         title: FadeTransition(
//           opacity: _fadeAnim,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 ['Тапсырыстарым', 'Жаңа тапсырыс', 'Хабарламалар', 'Профиль'][_currentIndex],
//                 style: GoogleFonts.poppins(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w800,
//                   color: const Color(0xFF1A237E),
//                   letterSpacing: -0.5,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 [
//                   'Менің барлық тапсырыстарым',
//                   'Жаңа тапсырыс жасау',
//                   'Соңғы хабарламалар',
//                   'Жеке ақпарат'
//                 ][_currentIndex],
//                 style: GoogleFonts.poppins(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.withAlpha(153),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           if (_currentIndex == 0)
//             Container(
//               margin: const EdgeInsets.only(right: 16),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: IconButton(
//                 icon: const Icon(Icons.filter_list_rounded, color: Colors.white, size: 22),
//                 onPressed: () {
//                   _showFilterDialog();
//                 },
//               ),
//             ),
//           if (_currentIndex == 3)
//             Container(
//               margin: const EdgeInsets.only(right: 16),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: IconButton(
//                 icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
//                 onPressed: () {
//                   _showSettingsDialog();
//                 },
//               ),
//             ),
//         ],
//         centerTitle: false,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(
//             height: 1,
//             color: Colors.grey.withAlpha(30),
//           ),
//         ),
//       ),
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 400),
//         switchInCurve: Curves.easeOutCubic,
//         switchOutCurve: Curves.easeInCubic,
//         transitionBuilder: (child, animation) {
//           return FadeTransition(
//             opacity: animation,
//             child: SlideTransition(
//               position: Tween<Offset>(
//                 begin: const Offset(0.05, 0),
//                 end: Offset.zero,
//               ).animate(animation),
//               child: child,
//             ),
//           );
//         },
//         child: _screens[_currentIndex],
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withAlpha(15),
//               blurRadius: 20,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//           type: BottomNavigationBarType.fixed,
//           elevation: 0,
//           backgroundColor: Colors.white,
//           selectedFontSize: 11,
//           unselectedFontSize: 10,
//           selectedItemColor: const Color(0xFF3949AB),
//           unselectedItemColor: Colors.grey.withAlpha(153),
//           selectedLabelStyle: GoogleFonts.poppins(
//             fontWeight: FontWeight.w700,
//             fontSize: 11,
//           ),
//           unselectedLabelStyle: GoogleFonts.poppins(
//             fontWeight: FontWeight.w500,
//             fontSize: 10,
//           ),
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.receipt_long_outlined, size: 24),
//               activeIcon: Icon(Icons.receipt_long_rounded, size: 24),
//               label: 'Тапсырыстар',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.add_circle_outline, size: 24),
//               activeIcon: Icon(Icons.add_circle_rounded, size: 24),
//               label: 'Жаңа',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.chat_outlined, size: 24),
//               activeIcon: Icon(Icons.chat_rounded, size: 24),
//               label: 'Чат',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person_outline, size: 24),
//               activeIcon: Icon(Icons.person_rounded, size: 24),
//               label: 'Профиль',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showFilterDialog() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//       ),
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 60,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.withAlpha(51),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               'Сүзгі',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w800,
//                 color: const Color(0xFF1A237E),
//                 letterSpacing: -0.5,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Тапсырыстарды сүзгілеу',
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.withAlpha(153),
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildFilterOption('Барлық тапсырыстар', Icons.list_alt, true),
//             const SizedBox(height: 12),
//             _buildFilterOption('Күтілуде', Icons.pending_outlined, false),
//             const SizedBox(height: 12),
//             _buildFilterOption('Қабылданды', Icons.check_circle_outline, false),
//             const SizedBox(height: 12),
//             _buildFilterOption('Аяқталды', Icons.done_all_outlined, false),
//             const SizedBox(height: 12),
//             _buildFilterOption('Бас тартылды', Icons.cancel_outlined, false),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF3949AB),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(28),
//                   ),
//                   textStyle: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 child: const Text('ҚОЛДАНУ'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showSettingsDialog() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//       ),
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 60,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.withAlpha(51),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               'Баптаулар',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w800,
//                 color: const Color(0xFF1A237E),
//                 letterSpacing: -0.5,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Профиль баптаулары',
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.withAlpha(153),
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildSettingOption('Тіл', 'Қазақша', Icons.language),
//             const SizedBox(height: 12),
//             _buildSettingOption('Хабарландырулар', 'Қосулы', Icons.notifications_outlined),
//             const SizedBox(height: 12),
//             _buildSettingOption('Құпиялық', '', Icons.lock_outlined),
//             const SizedBox(height: 12),
//             _buildSettingOption('Шығу', '', Icons.logout_outlined, isDanger: true),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: TextButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(28),
//                   ),
//                 ),
//                 child: Text(
//                   'Жабу',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterOption(String title, IconData icon, bool isSelected) {
//     return GestureDetector(
//       onTap: () {
//         // Фильтр логикасы
//         Navigator.pop(context);
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF8FAFE),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected ? const Color(0xFF3949AB) : Colors.grey.withAlpha(30),
//             width: isSelected ? 1.5 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isSelected ? const Color(0xFF3949AB).withAlpha(20) : Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Icon(icon, size: 20, color: isSelected ? const Color(0xFF3949AB) : Colors.grey),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: isSelected ? const Color(0xFF3949AB) : const Color(0xFF1A237E),
//                 ),
//               ),
//             ),
//             if (isSelected)
//               Container(
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3949AB),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.check, color: Colors.white, size: 14),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingOption(String title, String subtitle, IconData icon, {bool isDanger = false}) {
//     return GestureDetector(
//       onTap: () {
//         if (title == 'Шығу') {
//           // Шығу логикасы
//           Navigator.pop(context);
//         } else {
//           Navigator.pop(context);
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF8FAFE),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isDanger ? Colors.red.withAlpha(40) : Colors.grey.withAlpha(30),
//             width: 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isDanger ? Colors.red.withAlpha(20) : const Color(0xFF3949AB).withAlpha(20),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Icon(icon, size: 20, color: isDanger ? Colors.red : const Color(0xFF3949AB)),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.poppins(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: isDanger ? Colors.red : const Color(0xFF1A237E),
//                     ),
//                   ),
//                   if (subtitle.isNotEmpty)
//                     Text(
//                       subtitle,
//                       style: GoogleFonts.poppins(
//                         fontSize:  12,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey.withAlpha(128),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.chevron_right,
//               color: isDanger ? Colors.red : Colors.grey.withAlpha(128),
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// screens/client/client_home.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import 'my_orders_screen.dart';
import 'create_order_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  final _screens = const [
    MyOrdersScreen(),
    CreateOrderScreen(),
    ChatListScreen(userRole: 'client'),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
    _animCtrl.forward();
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
                ['Тапсырыстарым', 'Жаңа тапсырыс', 'Хабарламалар', 'Профиль'][_currentIndex],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A237E),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                [
                  'Менің барлық тапсырыстарым',
                  'Жаңа тапсырыс жасау',
                  'Соңғы хабарламалар',
                  'Жеке ақпарат'
                ][_currentIndex],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.withAlpha(153),
                ),
              ),
            ],
          ),
        ),
        actions: const [], // Барлық иконкалар алынып тасталды
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
        child: _screens[_currentIndex],
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
          selectedFontSize: 11,
          unselectedFontSize: 10,
          selectedItemColor: const Color(0xFF3949AB),
          unselectedItemColor: Colors.grey.withAlpha(153),
          selectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined, size: 24),
              activeIcon: Icon(Icons.receipt_long_rounded, size: 24),
              label: 'Тапсырыстар',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 24),
              activeIcon: Icon(Icons.add_circle_rounded, size: 24),
              label: 'Жаңа',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined, size: 24),
              activeIcon: Icon(Icons.chat_rounded, size: 24),
              label: 'Чат',
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
}