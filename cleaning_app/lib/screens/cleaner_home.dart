// screens/cleaner/cleaner_home.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import 'available_orders_screen.dart';
import 'accepted_orders_screen.dart';
import 'earnings_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';

class CleanerHomeScreen extends StatefulWidget {
  const CleanerHomeScreen({super.key});

  @override
  State<CleanerHomeScreen> createState() => _CleanerHomeScreenState();
}

class _CleanerHomeScreenState extends State<CleanerHomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

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
                ['Қолжетімді', 'Мен алған', 'Табыс', 'Чат', 'Профиль'][_currentIndex],
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
                  'Бос тапсырыстар',
                  'Қабылданған тапсырыстар',
                  'Жалпы табыс',
                  'Хабарламалар',
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
        actions: const [], // Фильтр иконкасы алынып тасталды
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
          const AvailableOrdersScreen(),
          const AcceptedOrdersScreen(),
          const EarningsScreen(),
          ChatListScreen(userRole: 'cleaner'),
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
              icon: Icon(Icons.search_rounded, size: 24),
              activeIcon: Icon(Icons.search_rounded, size: 24),
              label: 'Қолжетімді',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline, size: 24),
              activeIcon: Icon(Icons.check_circle, size: 24),
              label: 'Мен алған',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined, size: 24),
              activeIcon: Icon(Icons.monetization_on, size: 24),
              label: 'Табыс',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined, size: 24),
              activeIcon: Icon(Icons.chat_rounded, size: 24),
              label: 'Чат',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              activeIcon: Icon(Icons.person, size: 24),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}