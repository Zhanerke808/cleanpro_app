// // screens/auth/login_screen.dart
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../config/app_theme.dart';
// import '../../services/api_service.dart';
// import 'home_router.dart';
// import 'register_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   bool _loading = false;
//   bool _obscure = true;
//   late AnimationController _animCtrl;
//   late Animation<double> _fadeAnim;

//   @override
//   void initState() {
//     super.initState();
//     _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
//     _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
//     _animCtrl.forward();
//   }

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _loading = true);
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailCtrl.text.trim(),
//         password: _passCtrl.text.trim(),
//       );
//       final user = await ApiService.getProfile();
//       if (!mounted) return;
//       Navigator.pushReplacement(context, PageRouteBuilder(
//         pageBuilder: (_, __, ___) => HomeRouter(role: user.role),
//         transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
//         transitionDuration: const Duration(milliseconds: 500),
//       ));
//     } catch (e) {
//       String msg = 'Қате шықты';
//       if (e is FirebaseAuthException) {
//         msg = e.code == 'invalid-credential' ? 'Email немесе құпия сөз қате' : (e.message ?? msg);
//       }
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _emailCtrl.dispose();
//     _passCtrl.dispose();
//     _animCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.primaryDark, AppTheme.background]),
//         ),
//         child: SafeArea(
//           child: FadeTransition(
//             opacity: _fadeAnim,
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(32),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 50),
//                       Container(
//                         width: 110, height: 110,
//                         decoration: BoxDecoration(
//                           color: AppTheme.gold.withAlpha(20),
//                           borderRadius: BorderRadius.circular(35),
//                           border: Border.all(color: AppTheme.gold.withAlpha(80), width: 3),
//                           boxShadow: [BoxShadow(color: AppTheme.gold.withAlpha(25), blurRadius: 25)],
//                         ),
//                         child: const Icon(Icons.login_rounded, size: 55, color: AppTheme.gold),
//                       ),
//                       const SizedBox(height: 36),
//                       Text('ҚОШ КЕЛДІҢІЗ', style: GoogleFonts.montserrat(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3)),
//                       const SizedBox(height: 8),
//                       Text('Жүйеге кіріңіз', style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white54)),
//                       const SizedBox(height: 50),
//                       TextFormField(
//                         controller: _emailCtrl,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(labelText: 'Email', prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.gold)),
//                         validator: (v) => v!.isEmpty ? 'Email енгізіңіз' : null,
//                       ),
//                       const SizedBox(height: 18),
//                       TextFormField(
//                         controller: _passCtrl,
//                         obscureText: _obscure,
//                         decoration: InputDecoration(
//                           labelText: 'Құпия сөз',
//                           prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.gold),
//                           suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white38), onPressed: () => setState(() => _obscure = !_obscure)),
//                         ),
//                         validator: (v) => v!.length < 6 ? 'Кемінде 6 таңба' : null,
//                       ),
//                       const SizedBox(height: 30),
//                       _loading
//                           ? const CircularProgressIndicator(color: AppTheme.gold)
//                           : SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _login, child: const Text('КІРУ'))),
//                       const SizedBox(height: 24),
//                       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                         Text('Аккаунтыңыз жоқ па? ', style: GoogleFonts.montserrat(color: Colors.white54)),
//                         GestureDetector(
//                           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
//                           child: Text('Тіркелу', style: GoogleFonts.montserrat(color: AppTheme.gold, fontWeight: FontWeight.w700)),
//                         ),
//                       ]),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }// screens/auth/login_screen.dart
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../services/api_service.dart';
import 'home_router.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideUpAnim;
  late Animation<Offset> _slideDownAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideUpAnim = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animCtrl, curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic)),
    );
    _slideDownAnim = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animCtrl, curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic)),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: const Interval(0.3, 0.9, curve: Curves.easeOutBack)),
    );
    
    _animCtrl.forward();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );
      final user = await ApiService.getProfile();
      if (!mounted) return;
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => HomeRouter(role: user.role),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ));
    } catch (e) {
      String msg = 'Қате кетті';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-credential': msg = 'Email немесе құпия сөз қате'; break;
          case 'user-disabled': msg = 'Пайдаланушы блокталған'; break;
          case 'too-many-requests': msg = 'Көп әрекет, күте тұрыңыз'; break;
          default: msg = e.message ?? msg;
        }
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(30),
              ),
              child: const Icon(Icons.error_outline, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(msg, style: const TextStyle(fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: const Color(0xFFE57373),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _animCtrl.dispose();
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
              Color(0xFF1A237E),
              Color(0xFF283593),
              Color(0xFF3949AB),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Анимациялық шеңберлер (жоғарғы жақ)
            AnimatedBuilder(
              animation: _animCtrl,
              builder: (context, child) {
                return SlideTransition(
                  position: _slideDownAnim,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFloatingCircle(80, 0.3, 1),
                            _buildFloatingCircle(120, 0.5, 2),
                            _buildFloatingCircle(60, 0.2, 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            // Анимациялық шеңберлер (төменгі жақ)
            AnimatedBuilder(
              animation: _animCtrl,
              builder: (context, child) {
                return Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _slideUpAnim,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFloatingCircle(100, 0.4, 4),
                        _buildFloatingCircle(70, 0.25, 5),
                        _buildFloatingCircle(140, 0.6, 6),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Негізгі контент
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          
                          // Логотип
                          ScaleTransition(
                            scale: _scaleAnim,
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.white, Color(0xFFE8EAF6)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(45),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(40),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                    offset: const Offset(0, 20),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withAlpha(80),
                                    blurRadius: 30,
                                    offset: const Offset(-8, -8),
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.cleaning_services_rounded,
                                    size: 65,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 50),
                          
                          // Қош келу мәтіні
                          SlideTransition(
                            position: _slideUpAnim,
                            child: Column(
                              children: [
                                Text(
                                  'Қош келдіңіз',
                                  style: GoogleFonts.poppins(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withAlpha(30),
                                        blurRadius: 15,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Аккаунтыңызға кіріңіз',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withAlpha(230),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 60),
                          
                          // Кіру карточкасы
                          SlideTransition(
                            position: _slideUpAnim,
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(245),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(30),
                                    blurRadius: 60,
                                    spreadRadius: 10,
                                    offset: const Offset(0, 30),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withAlpha(102),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Email өрісі
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withAlpha(15),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: _emailCtrl,
                                      keyboardType: TextInputType.emailAddress,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF1A237E),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Электрондық пошта',
                                        hintStyle: GoogleFonts.poppins(
                                          color: Colors.grey.withAlpha(128),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        prefixIcon: Container(
                                          margin: const EdgeInsets.only(right: 8),
                                          child: Icon(
                                            Icons.email_outlined,
                                            color: const Color(0xFF3949AB),
                                            size: 22,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28),
                                          borderSide: BorderSide(color: Colors.grey.withAlpha(50)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28),
                                          borderSide: const BorderSide(color: Color(0xFF3949AB), width: 2),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          vertical: 18,
                                          horizontal: 20,
                                        ),
                                      ),
                                      validator: (v) => v!.isEmpty ? 'Email енгізіңіз' : null,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 22),
                                  
                                  // Құпия сөз өрісі
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withAlpha(15),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: _passCtrl,
                                      obscureText: _obscure,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF1A237E),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Құпия сөз',
                                        hintStyle: GoogleFonts.poppins(
                                          color: Colors.grey.withAlpha(128),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        prefixIcon: Container(
                                          margin: const EdgeInsets.only(right: 8),
                                          child: Icon(
                                            Icons.lock_outline,
                                            color: const Color(0xFF3949AB),
                                            size: 22,
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscure
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: Colors.grey.withAlpha(179),
                                            size: 22,
                                          ),
                                          onPressed: () => setState(() => _obscure = !_obscure),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28),
                                          borderSide: BorderSide(color: Colors.grey.withAlpha(50)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28),
                                          borderSide: const BorderSide(color: Color(0xFF3949AB), width: 2),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          vertical: 18,
                                          horizontal: 20,
                                        ),
                                      ),
                                      validator: (v) => v!.length < 6 ? 'Кемінде 6 таңба' : null,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 40),
                                  
                                  // Кіру батырмасы
                                  _loading
                                      ? Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(32),
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
                                            ),
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: _login,
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(vertical: 18),
                                              backgroundColor: const Color(0xFF3949AB),
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(32),
                                              ),
                                              textStyle: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1,
                                              ),
                                              shadowColor: const Color(0xFF3949AB).withAlpha(100),
                                            ),
                                            child: const Text('КІРУ'),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Тіркелу сілтемесі
                          SlideTransition(
                            position: _slideUpAnim,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(20),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: Colors.white.withAlpha(50),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Аккаунтыңыз жоқ па? ',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withAlpha(230),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                    ),
                                    child: Text(
                                      'Тіркелу',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                        decorationThickness: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFloatingCircle(double size, double opacity, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 3000),
      builder: (context, value, child) {
        final double offsetY = 15 * sin(value * 2 * pi + index);
        return Transform.translate(
          offset: Offset(0, offsetY),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withAlpha((opacity * 40).toInt()),
                  Colors.white.withAlpha(0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}