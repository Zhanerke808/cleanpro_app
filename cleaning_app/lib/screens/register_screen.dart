// // screens/auth/register_screen.dart
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../config/app_theme.dart';
// import '../services/api_service.dart';
// import 'home_router.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   String _role = 'client';
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

//   Future<void> _register() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _loading = true);
//     try {
//       final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailCtrl.text.trim(),
//         password: _passCtrl.text.trim(),
//       );
//       await ApiService.saveProfile(_nameCtrl.text.trim(), _phoneCtrl.text.trim(), _role);
//       if (!mounted) return;
//       Navigator.pushReplacement(context, PageRouteBuilder(
//         pageBuilder: (_, __, ___) => HomeRouter(role: _role),
//         transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
//         transitionDuration: const Duration(milliseconds: 500),
//       ));
//     } catch (e) {
//       String msg = 'Қате шықты';
//       if (e is FirebaseAuthException) {
//         msg = e.code == 'email-already-in-use' ? 'Бұл email тіркелген' : (e.message ?? msg);
//       }
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _emailCtrl.dispose();
//     _phoneCtrl.dispose();
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
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(32),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 30),
//                     Row(children: [IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppTheme.gold), onPressed: () => Navigator.pop(context))]),
//                     Text('ТІРКЕЛУ', style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3)),
//                     const SizedBox(height: 8),
//                     Text('Жаңа аккаунт жасау', style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white54)),
//                     const SizedBox(height: 40),
//                     _buildField(_nameCtrl, 'Аты-жөні', Icons.person_outline),
//                     const SizedBox(height: 18),
//                     _buildField(_emailCtrl, 'Email', Icons.email_outlined, TextInputType.emailAddress),
//                     const SizedBox(height: 18),
//                     _buildField(_phoneCtrl, 'Телефон', Icons.phone_outlined, TextInputType.phone),
//                     const SizedBox(height: 18),
//                     TextFormField(
//                       controller: _passCtrl,
//                       obscureText: _obscure,
//                       decoration: InputDecoration(
//                         labelText: 'Құпия сөз',
//                         prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.gold),
//                         suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white38), onPressed: () => setState(() => _obscure = !_obscure)),
//                       ),
//                       validator: (v) => v!.length < 6 ? 'Кемінде 6 таңба' : null,
//                     ),
//                     const SizedBox(height: 24),
//                     _buildRoleSelector(),
//                     const SizedBox(height: 32),
//                     _loading
//                         ? const CircularProgressIndicator(color: AppTheme.gold)
//                         : SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _register, child: const Text('ТІРКЕЛУ'))),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildField(TextEditingController ctrl, String label, IconData icon, [TextInputType? type]) {
//     return TextFormField(
//       controller: ctrl,
//       keyboardType: type,
//       decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: AppTheme.gold)),
//       validator: (v) => v!.isEmpty ? '$label енгізіңіз' : null,
//     );
//   }

//   Widget _buildRoleSelector() {
//     return Container(
//       decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withAlpha(15))),
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           const Icon(Icons.work_outline, color: AppTheme.gold, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _role,
//                 dropdownColor: AppTheme.surface,
//                 style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
//                 isExpanded: true,
//                 items: [
//                   DropdownMenuItem(value: 'client', child: Row(children: [const Icon(Icons.home, color: Colors.blue, size: 20), const SizedBox(width: 8), Text('Клиент')])),
//                   DropdownMenuItem(value: 'cleaner', child: Row(children: [const Icon(Icons.cleaning_services, color: Colors.green, size: 20), const SizedBox(width: 8), Text('Клинер')])),
//                 ],
//                 onChanged: (v) => setState(() => _role = v!),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// screens/auth/register_screen.dart
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../services/api_service.dart';
import 'home_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _role = 'client';
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

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );
      await ApiService.saveProfile(_nameCtrl.text.trim(), _phoneCtrl.text.trim(), _role);
      if (!mounted) return;
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => HomeRouter(role: _role),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ));
    } catch (e) {
      String msg = 'Қате кетті';
      if (e is FirebaseAuthException) {
        msg = e.code == 'email-already-in-use' ? 'Бұл email тіркелген' : (e.message ?? msg);
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
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
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
                          const SizedBox(height: 20),
                          
                          // Артқа батырмасы
                          SlideTransition(
                            position: _slideDownAnim,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(30),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                                    onPressed: () => Navigator.pop(context),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Логотип
                          ScaleTransition(
                            scale: _scaleAnim,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.white, Color(0xFFE8EAF6)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(35),
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
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person_add_alt_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 36),
                          
                          // Тақырып мәтіні
                          SlideTransition(
                            position: _slideUpAnim,
                            child: Column(
                              children: [
                                Text(
                                  'Тіркелу',
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
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
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Жаңа аккаунт жасау',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withAlpha(230),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 48),
                          
                          // Тіркелу карточкасы
                          SlideTransition(
                            position: _slideUpAnim,
                            child: Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(245),
                                borderRadius: BorderRadius.circular(48),
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
                                  // Аты-жөні өрісі
                                  _buildField(
                                    _nameCtrl, 
                                    'Аты-жөні', 
                                    Icons.person_outline,
                                    TextInputType.text,
                                  ),
                                  const SizedBox(height: 18),
                                  
                                  // Email өрісі
                                  _buildField(
                                    _emailCtrl, 
                                    'Электрондық пошта', 
                                    Icons.email_outlined,
                                    TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 18),
                                  
                                  // Телефон өрісі
                                  _buildField(
                                    _phoneCtrl, 
                                    'Телефон', 
                                    Icons.phone_outlined,
                                    TextInputType.phone,
                                  ),
                                  const SizedBox(height: 18),
                                  
                                  // Құпия сөз өрісі
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
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
                                          borderRadius: BorderRadius.circular(24),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(24),
                                          borderSide: BorderSide(color: Colors.grey.withAlpha(50)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(24),
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
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Рөл таңдау
                                  _buildRoleSelector(),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Тіркелу батырмасы
                                  _loading
                                      ? Container(
                                          height: 56,
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
                                            onPressed: _register,
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              backgroundColor: const Color(0xFF3949AB),
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(32),
                                              ),
                                              textStyle: GoogleFonts.poppins(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1,
                                              ),
                                              shadowColor: const Color(0xFF3949AB).withAlpha(100),
                                            ),
                                            child: const Text('ТІРКЕЛУ'),
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

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, TextInputType? type) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A237E),
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.withAlpha(128),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 8),
            child: Icon(
              icon,
              color: const Color(0xFF3949AB),
              size: 22,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.grey.withAlpha(50)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: Color(0xFF3949AB), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
        ),
        validator: (v) => v!.isEmpty ? '$label енгізіңіз' : null,
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withAlpha(50)),
        ),
        child: DropdownButtonFormField<String>(
          value: _role,
          dropdownColor: Colors.white,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFF3949AB), size: 28),
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A237E),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: 'Рөл таңдаңыз',
            labelStyle: GoogleFonts.poppins(
              color: Colors.grey.withAlpha(128),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.badge_outlined,
                color: const Color(0xFF3949AB),
                size: 22,
              ),
            ),
          ),
          items: [
            DropdownMenuItem(
              value: 'client', 
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.home_outlined, color: Colors.blue, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Клиент', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'cleaner', 
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.cleaning_services, color: Colors.green, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Клинер', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
          onChanged: (v) => setState(() => _role = v!),
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