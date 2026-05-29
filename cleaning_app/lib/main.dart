// // main.dart
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'screens/splash_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: "AIzaSyCS-ynaOqtJGOLS9ds80n0zXrnN917xd9A",
//       appId: "1:565107497082:web:c04f4dca85f223974d83c3",
//       messagingSenderId: "565107497082",
//       projectId: "clinic-managment-a7666",
//       authDomain: "clinic-managment-a7666.firebaseapp.com",
//       storageBucket: "clinic-managment-a7666.firebasestorage.app",
//       measurementId: "G-RECZM4JJ7Y",
//     ),
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'CleanPro - Клининг Қызметі',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         colorScheme: ColorScheme.dark(
//           primary: const Color(0xFF1A237E),
//           secondary: const Color(0xFFFFD700),
//           surface: const Color(0xFF0F0F1A),
//           background: const Color(0xFF0A0A14),
//           error: const Color(0xFFFF4757),
//         ),
//         scaffoldBackgroundColor: const Color(0xFF0A0A14),
//         cardTheme: CardThemeData(
//           color: const Color(0xFF1A1A2E),
//           elevation: 8,
//           shadowColor: const Color(0xFFFFD700).withAlpha(30),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(24),
//             side: BorderSide(color: Colors.white.withAlpha(15)),
//           ),
//         ),
//         appBarTheme: AppBarTheme(
//           backgroundColor: const Color(0xFF0A0A14),
//           elevation: 0,
//           centerTitle: true,
//           titleTextStyle: GoogleFonts.montserrat(
//             fontSize: 22,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//             letterSpacing: 1.2,
//           ),
//           iconTheme: const IconThemeData(color: Color(0xFFFFD700)),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFFFD700),
//             foregroundColor: const Color(0xFF0A0A14),
//             padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             elevation: 8,
//             shadowColor: const Color(0xFFFFD700).withAlpha(80),
//             textStyle: GoogleFonts.montserrat(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: const Color(0xFF1A1A2E),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide(color: Colors.white.withAlpha(20)),
//           ),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//           labelStyle: GoogleFonts.montserrat(color: Colors.white60, fontSize: 14),
//           hintStyle: GoogleFonts.montserrat(color: Colors.white30, fontSize: 14),
//         ),
//         textTheme: GoogleFonts.montserratTextTheme(
//           ThemeData.dark().textTheme,
//         ).copyWith(
//           headlineLarge: GoogleFonts.montserrat(
//             fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: Colors.white,
//           ),
//           headlineMedium: GoogleFonts.montserrat(
//             fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white,
//           ),
//           bodyLarge: GoogleFonts.montserrat(
//             fontSize: 16, color: Colors.white70,
//           ),
//           bodyMedium: GoogleFonts.montserrat(
//             fontSize: 14, color: Colors.white60,
//           ),
//         ),
//         bottomNavigationBarTheme: BottomNavigationBarThemeData(
//           backgroundColor: const Color(0xFF0A0A14),
//           selectedItemColor: const Color(0xFFFFD700),
//          unselectedItemColor: Colors.white38,
//           type: BottomNavigationBarType.fixed,
//           selectedLabelStyle: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600),
//           unselectedLabelStyle: GoogleFonts.montserrat(fontSize: 11),
//           elevation: 0,
//         ),
//         snackBarTheme: SnackBarThemeData(
//           backgroundColor: const Color(0xFF1A1A2E),
//           contentTextStyle: GoogleFonts.montserrat(color: Colors.white),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           behavior: SnackBarBehavior.floating,
//         ),
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }


// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Статус бар стилі
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCS-ynaOqtJGOLS9ds80n0zXrnN917xd9A",
      appId: "1:565107497082:web:c04f4dca85f223974d83c3",
      messagingSenderId: "565107497082",
      projectId: "clinic-managment-a7666",
      authDomain: "clinic-managment-a7666.firebaseapp.com",
      storageBucket: "clinic-managment-a7666.firebasestorage.app",
      measurementId: "G-RECZM4JJ7Y",
    ),
  );
  runApp(const CleanProApp());
}

class CleanProApp extends StatelessWidget {
  const CleanProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleanPro - Клининг Қызметі',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}