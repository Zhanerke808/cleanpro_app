// screens/splash_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'home_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    
    _fadeAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOut))
    );
    
    _slideAnim = Tween(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic))
    );
    
    _scaleAnim = Tween(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack))
    );
    
    _rotateAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic))
    );
    
    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final profile = await ApiService.getProfile();
        if (!mounted) return;
        _goTo(HomeRouter(role: profile.role));
      } catch (e) {
        if (!mounted) return;
        _goTo(const LoginScreen());
      }
    } else {
      if (!mounted) return;
      _goTo(const LoginScreen());
    }
  }

  void _goTo(Widget page) {
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 600),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E), // Deep indigo
              Color(0xFF283593), // Rich indigo
              Color(0xFF3949AB), // Vibrant blue
            ],
          ),
        ),
        child: Stack(
          children: [
            // Декоративті шеңберлер (фон)
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withAlpha(15),
                      Colors.white.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withAlpha(10),
                      Colors.white.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
            
            // Негізгі контент
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Логотип
                      Opacity(
                        opacity: _fadeAnim.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnim.value),
                          child: Transform.scale(
                            scale: _scaleAnim.value,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withAlpha(30),
                                    Colors.white.withAlpha(15),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(45),
                                border: Border.all(
                                  color: Colors.white.withAlpha(80),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(30),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                    offset: const Offset(0, 20),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withAlpha(20),
                                    blurRadius: 30,
                                    offset: const Offset(-5, -5),
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFD700), Color(0xFFFFC107)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(37),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.cleaning_services_rounded,
                                    size: 75,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Бренд атауы
                      Opacity(
                        opacity: _fadeAnim.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnim.value * 0.7),
                          child: Column(
                            children: [
                              Text(
                                'CLEANPRO',
                                style: GoogleFonts.poppins(
                                  fontSize: 46,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 6,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withAlpha(30),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withAlpha(102),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'КЛИНИНГ ҚЫЗМЕТІ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.white.withAlpha(230),
                                    letterSpacing: 6,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 80),
                      
                      // Загрузка индикаторы
                      Opacity(
                        opacity: _fadeAnim.value,
                        child: Transform.rotate(
                          angle: _rotateAnim.value * 6.28318, // 360 градус
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white.withAlpha(204),
                              backgroundColor: Colors.white.withAlpha(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}