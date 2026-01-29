import 'package:flutter/material.dart';

/// Obsidian Black Design System
class AeroColors {
  // Primary colors
  static const deepObsidian = Color(0xFF0B0B0B); // Ana arka plan
  static const electricBlue = Color(0xFF257BF4); // Aksan rengi
  static const obsidianCard = Color(0xFF111418); // Kart arka planı
  static const cardBorder = Color(0x0DFFFFFF); // İnce border (#ffffff0d)
  
  // Finance colors
  static const incomeGreen = Color(0xFF10B981); // Gelir (yeşil)
  static const expenseShopping = Color(0xFFEC4899); // Alışveriş
  static const expenseMarket = Color(0xFFF59E0B); // Market
  static const expenseTransport = Color(0xFF8B5CF6); // Ulaşım
  static const expenseFood = Color(0xFFEF4444); // Yiyecek
  static const expenseBills = Color(0xFF3B82F6); // Faturalar
  static const expenseOther = Color(0xFF6B7280); // Diğer
  
  // Text colors
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0x99FFFFFF);
  static const textTertiary = Color(0x61FFFFFF);
}

class AeroTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      primaryColor: AeroColors.electricBlue,
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          letterSpacing: 3,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 48,
          fontWeight: FontWeight.w900,
          letterSpacing: -2,
          color: Color(0xFF1A1A1A),
        ),
        displayMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A1A),
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(0xFF1A1A1A),
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Color(0xFF1A1A1A),
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: Color(0xFF666666),
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          color: Color(0xFF666666),
        ),
      ),
      
      iconTheme: const IconThemeData(
        color: Color(0xFF1A1A1A),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AeroColors.electricBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black54,
          side: const BorderSide(color: Colors.black12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      
      // Drawer theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Colors.black12,
        thickness: 1,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AeroColors.deepObsidian,
      primaryColor: AeroColors.electricBlue,
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AeroColors.deepObsidian,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          letterSpacing: 3,
          fontWeight: FontWeight.bold,
          color: AeroColors.textPrimary,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: AeroColors.obsidianCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AeroColors.cardBorder,
            width: 1,
          ),
        ),
      ),
      
      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 48,
          fontWeight: FontWeight.w900,
          letterSpacing: -2,
          color: AeroColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AeroColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AeroColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AeroColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: AeroColors.textTertiary,
        ),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AeroColors.electricBlue,
          foregroundColor: AeroColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AeroColors.textSecondary,
          side: const BorderSide(color: AeroColors.cardBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      
      // Drawer theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: AeroColors.deepObsidian,
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AeroColors.cardBorder,
        thickness: 1,
      ),
    );
  }
}
