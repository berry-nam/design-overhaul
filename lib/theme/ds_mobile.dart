import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Version B: HTML 프로토타입 기반 모바일 전용 디자인시스템
/// Source: mobile-search.html, mobile-detail.html CSS variables
/// Slate gray scale (blue tint) 사용 — 모바일에서 더 세련된 느낌
class DsMobile {
  DsMobile._();

  // ── Blue (Brand) ──
  static const blue50 = Color(0xFFEBF1FB);
  static const blue100 = Color(0xFFC8D9F5);
  static const blue200 = Color(0xFF9BBBEE);
  static const blue300 = Color(0xFF6D9DE7);
  static const blue400 = Color(0xFF3A7ADF);
  static const blue500 = Color(0xFF0549CC);
  static const blue600 = Color(0xFF043EB0);
  static const blue700 = Color(0xFF033293);
  static const blue800 = Color(0xFF022777);

  // ── Slate (blue-tinted gray) ──
  static const slate50 = Color(0xFFF7F8FA);
  static const slate100 = Color(0xFFEFF1F5);
  static const slate200 = Color(0xFFE0E4EB);
  static const slate300 = Color(0xFFCCD2DB);
  static const slate400 = Color(0xFF9AA3B4);
  static const slate500 = Color(0xFF6B7689);
  static const slate600 = Color(0xFF4A5567);
  static const slate700 = Color(0xFF374151);
  static const slate800 = Color(0xFF1F2937);
  static const slate900 = Color(0xFF111827);

  // ── Emerald ──
  static const emerald50 = Color(0xFFECFDF5);
  static const emerald400 = Color(0xFF34D399);
  static const emerald500 = Color(0xFF10B981);
  static const emerald600 = Color(0xFF059669);

  // ── Red ──
  static const red50 = Color(0xFFFEF2F2);
  static const red400 = Color(0xFFF87171);
  static const red500 = Color(0xFFEF4444);
  static const red600 = Color(0xFFDC2626);

  // ── Amber ──
  static const amber50 = Color(0xFFFFFBEB);
  static const amber400 = Color(0xFFFBBF24);
  static const amber500 = Color(0xFFF59E0B);
  static const amber600 = Color(0xFFD97706);

  // ── Purple ──
  static const purple50 = Color(0xFFF5F3FF);
  static const purple400 = Color(0xFFA78BFA);
  static const purple500 = Color(0xFF8B5CF6);

  // ── Teal ──
  static const teal50 = Color(0xFFF0FDFA);
  static const teal500 = Color(0xFF14B8A6);

  // ── Orange ──
  static const orange50 = Color(0xFFFFF7ED);
  static const orange500 = Color(0xFFF97316);
  static const orange600 = Color(0xFFEA580C);

  // ── Semantic aliases ──
  static const brand = blue500;
  static const brandHover = blue600;
  static const error = red500;
  static const success = emerald500;
  static const warning = amber500;
  static const info = purple500;

  // ── Text ──
  static const text = slate900;
  static const textSub = slate500;
  static const textMuted = slate400;
  static const textBrand = blue500;
  static const textDanger = red600;
  static const textPositive = emerald600;
  static const textWarning = amber600;

  // ── Background ──
  static const bg = Color(0xFFFFFFFF);
  static const bgSurface = slate50;
  static const bgDanger = red50;
  static const bgSuccess = emerald50;
  static const bgWarning = amber50;
  static const bgBrand = blue50;
  static const bgHighlight = purple50;

  // ── Border ──
  static const border = slate200;
  static const borderLight = slate100;
  static const borderBrand = blue500;

  // ── Chart Colors (5색 — 색각이상 대응, hue 채널 분산) ──
  static const chartColors = [blue500, amber500, emerald500, purple500, red500];
  static const chartColorsLight = [blue200, amber400, emerald400, purple400, red400];

  // ── ThemeData ──
  static ThemeData get theme => ThemeData(
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.light(
      primary: brand,
      onPrimary: Colors.white,
      surface: bg,
      onSurface: text,
      error: error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: text,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: text,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: borderLight,
      thickness: 1,
      space: 0,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: text, letterSpacing: -0.3),
      headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: text),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: text),
      titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: text),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text),
      bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: text),
      bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSub),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: textSub),
      labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: text),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textSub),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textMuted),
    ),
  );

  // ── Spacing & Radius ──
  static const double radiusSm = 6;
  static const double radius = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double sectionPad = 16;
  static const double chipHeight = 36;
  static const double touchMin = 44;
  static const double tabBarHeight = 56;
  static const double sheetRadius = 20;

  static BoxShadow get shadowSm => BoxShadow(
    color: slate900.withValues(alpha: 0.04),
    blurRadius: 2,
    offset: const Offset(0, 1),
  );

  static BoxShadow get shadow => BoxShadow(
    color: slate900.withValues(alpha: 0.06),
    blurRadius: 3,
    offset: const Offset(0, 1),
  );

  static BoxShadow get shadowMd => BoxShadow(
    color: slate900.withValues(alpha: 0.06),
    blurRadius: 6,
    offset: const Offset(0, 4),
  );
}
