import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double radiusSm = 6;
  static const double radius = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double sectionPad = 16;
  static const double chipHeight = 36;
  static const double touchMin = 44;
  static const double tabBarHeight = 56;
  static const double sheetRadius = 20;

  static ThemeData get theme => ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.light(
          primary: AppColors.brand,
          onPrimary: Colors.white,
          surface: AppColors.bg,
          onSurface: AppColors.text,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.text,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.borderLight,
          thickness: 1,
          space: 0,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text, letterSpacing: -0.3),
          headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.text),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text),
          titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.text),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text),
          bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.text),
          bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSub),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSub),
          labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSub),
          labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textMuted),
        ),
      );

  static BoxShadow get shadowSm => BoxShadow(
        color: const Color(0xFF111827).withValues(alpha: 0.04),
        blurRadius: 2,
        offset: const Offset(0, 1),
      );

  static BoxShadow get shadow => BoxShadow(
        color: const Color(0xFF111827).withValues(alpha: 0.06),
        blurRadius: 3,
        offset: const Offset(0, 1),
      );

  static BoxShadow get shadowMd => BoxShadow(
        color: const Color(0xFF111827).withValues(alpha: 0.06),
        blurRadius: 6,
        offset: const Offset(0, 4),
      );
}
