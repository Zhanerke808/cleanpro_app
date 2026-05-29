// config/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ==================== НЕГІЗГІ КОРПОРАТИВТІ ТҮСТЕР ====================
  
  // Негізгі түстер (Indigo/Purple схемасы)
  static const Color primary = Color(0xFF3949AB);      // Vibrant Indigo
  static const Color primaryDark = Color(0xFF1A237E);  // Deep Indigo  
  static const Color primaryLight = Color(0xFF5C6BC0); // Light Indigo
  
  // Акцент түстер (Gold/Sarı схемасы)
  static const Color accent = Color(0xFFFFD700);       // Алтын сары
  static const Color accentDark = Color(0xFFFFC107);   // Қою алтын
  static const Color accentLight = Color(0xFFFFE082);  // Ашық алтын
  
  // Функционалды түстер
  static const Color success = Color(0xFF4CAF50);      // Жасыл
  static const Color error = Color(0xFFF44336);        // Қызыл
  static const Color warning = Color(0xFFFF9800);      // Қызғылт сары
  static const Color info = Color(0xFF2196F3);         // Көк
  
  // Бейтарап түстер
  static const Color background = Color(0xFFF8FAFE);   // Ашық көкшіл сұр
  static const Color surface = Color(0xFFFFFFFF);      // Ақ
  static const Color surfaceAlt = Color(0xFFF0F2F8);   // Ашық сұр
  static const Color divider = Color(0xFFE2E6EF);      // Бөлгіш сызық
  
  // Мәтін түстері
  static const Color textPrimary = Color(0xFF1A237E);  // Қою көк
  static const Color textSecondary = Color(0xFF546E7A); // Сұр
  static const Color textHint = Color(0xFF90A4AE);      // Ашық сұр
  static const Color textLight = Color(0xFFB0BEC5);     // Өте ашық сұр

  // ==================== ГЕТТЕР (ҚОСЫМША ЫҢҒАЙЛЫЛЫҚ) ====================
  
  static Color get primaryGradientStart => primary;
  static Color get primaryGradientEnd => primaryLight;
  static Color get accentGradientStart => accent;
  static Color get accentGradientEnd => accentDark;
  
  static Color get gold => accent;
  static Color get goldLight => accentLight;
  
  // Статус түстері (геттер)
  static Color get statusPending => warning;
  static Color get statusAccepted => info;
  static Color get statusInProgress => const Color(0xFF9C27B0); // Күлгін
  static Color get statusCompleted => success;
  static Color get statusCancelled => error;
  
  // Рөл түстері (геттер)
  static Color get roleAdmin => error;
  static Color get roleCleaner => success;
  static Color get roleClient => info;

  // ==================== ГРАДИЕНТТЕР ====================
  
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static LinearGradient get accentGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark],
  );
  
  static LinearGradient get darkGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary],
  );
  
  static LinearGradient get backgroundGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [background, Color(0xFFE8ECF1)],
  );

  // ==================== КӨЛЕҢКЕЛЕР ====================
  
  static BoxShadow get cardShadow => BoxShadow(
    color: Colors.black.withAlpha(12),
    blurRadius: 20,
    spreadRadius: 2,
    offset: const Offset(0, 8),
  );
  
  static BoxShadow get softShadow => BoxShadow(
    color: Colors.black.withAlpha(8),
    blurRadius: 15,
    offset: const Offset(0, 4),
  );
  
  static BoxShadow get primaryShadow => BoxShadow(
    color: primary.withAlpha(40),
    blurRadius: 20,
    spreadRadius: 5,
    offset: const Offset(0, 10),
  );
  
  static BoxShadow get accentShadow => BoxShadow(
    color: accent.withAlpha(40),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  // ==================== ТЕМА ====================
  
  static ThemeData get lightTheme {
    final textTheme = TextTheme(
      // Үлкен тақырыптар
      displayLarge: GoogleFonts.poppins(
        fontSize: 48, 
        fontWeight: FontWeight.w800, 
        color: textPrimary, 
        letterSpacing: -1,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 36, 
        fontWeight: FontWeight.w800, 
        color: textPrimary, 
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 32, 
        fontWeight: FontWeight.w700, 
        color: textPrimary, 
        letterSpacing: -0.5,
      ),
      
      // Тақырыптар
      headlineLarge: GoogleFonts.poppins(
        fontSize: 28, 
        fontWeight: FontWeight.w800, 
        color: textPrimary, 
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24, 
        fontWeight: FontWeight.w700, 
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 20, 
        fontWeight: FontWeight.w700, 
        color: textPrimary,
      ),
      
      // Тақырышалар
      titleLarge: GoogleFonts.poppins(
        fontSize: 18, 
        fontWeight: FontWeight.w700, 
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16, 
        fontWeight: FontWeight.w600, 
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14, 
        fontWeight: FontWeight.w600, 
        color: textSecondary,
      ),
      
      // Негізгі мәтін
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16, 
        fontWeight: FontWeight.w500, 
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14, 
        fontWeight: FontWeight.w500, 
        color: textSecondary,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12, 
        fontWeight: FontWeight.w500, 
        color: textHint,
      ),
      
      // Кішкентай мәтін
      labelLarge: GoogleFonts.poppins(
        fontSize: 14, 
        fontWeight: FontWeight.w600, 
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12, 
        fontWeight: FontWeight.w600, 
        color: textSecondary,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10, 
        fontWeight: FontWeight.w600, 
        color: textHint,
      ),
    );

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        primaryContainer: primaryLight,
        secondary: accent,
        secondaryContainer: accentLight,
        surface: surface,
        surfaceContainerHighest: surfaceAlt,
        onSurface: textPrimary,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      fontFamily: GoogleFonts.poppins().fontFamily,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        foregroundColor: textPrimary,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 70,
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shadowColor: Colors.black.withAlpha(12),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          elevation: 0,
          shadowColor: primary.withAlpha(60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16, 
            fontWeight: FontWeight.w700, 
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary.withAlpha(102), width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16, 
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      
      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14, 
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        labelStyle: GoogleFonts.poppins(
          color: textSecondary, 
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.poppins(
          color: textHint, 
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: GoogleFonts.poppins(
          color: primary, 
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: primary,
        suffixIconColor: textHint,
      ),
      
      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textHint,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11, 
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        elevation: 8,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),
      
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: GoogleFonts.poppins(
          color: Colors.white, 
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22, 
          fontWeight: FontWeight.w800, 
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 14, 
          fontWeight: FontWeight.w500, 
          color: textSecondary,
        ),
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: surfaceAlt,
        selectedColor: primary.withAlpha(20),
        labelStyle: GoogleFonts.poppins(
          fontSize: 13, 
          fontWeight: FontWeight.w600, 
          color: textPrimary,
        ),
        secondaryLabelStyle: GoogleFonts.poppins(
          fontSize: 13, 
          fontWeight: FontWeight.w700, 
          color: primary,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      
      // TabBar
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: textHint,
        indicatorColor: accent,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14, 
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: divider, 
        thickness: 1, 
        space: 1,
      ),
      
      // ListTile
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // PopupMenu
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
      ),
      
      // ProgressIndicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        circularTrackColor: Color(0xFFE8ECF1),
        linearTrackColor: Color(0xFFE8ECF1),
      ),
    );
  }
}