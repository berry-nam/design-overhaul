import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Version A: 쿠키딜 웹 디자인시스템 직접 포팅
/// Source: cookiedeal-web-nextjs/src/styles/_colors.scss, _typos.scss, theme.ts, global.scss
class DsWeb {
  DsWeb._();

  // ── Primary (Blue) ──
  static const primary50 = Color(0xFFEBF1FB);
  static const primary100 = Color(0xFFD8E2F7);
  static const primary200 = Color(0xFFA5BDED);
  static const primary300 = Color(0xFF6A93E1);
  static const primary400 = Color(0xFF376DD6);
  static const primary500 = Color(0xFF0549CC);
  static const primary600 = Color(0xFF043AA3);
  static const primary700 = Color(0xFF032C7B);
  static const primary800 = Color(0xFF022362);
  static const primary900 = Color(0xFF021A4A);

  // ── Gray (neutral, NOT Slate) ──
  static const gray50 = Color(0xFFF8F9FA);
  static const gray100 = Color(0xFFF1F3F5);
  static const gray200 = Color(0xFFE9ECEF);
  static const gray300 = Color(0xFFDEE2E6);
  static const gray400 = Color(0xFFCED4DA);
  static const gray500 = Color(0xFFADB5BD);
  static const gray600 = Color(0xFF868E96);
  static const gray700 = Color(0xFF495057);
  static const gray800 = Color(0xFF343A40);
  static const gray900 = Color(0xFF212529);

  // ── Red ──
  static const red50 = Color(0xFFFCF0F0);
  static const red100 = Color(0xFFF9E2E2);
  static const red200 = Color(0xFFF2BBBB);
  static const red300 = Color(0xFFE98F8F);
  static const red400 = Color(0xFFE16969);
  static const red500 = Color(0xFFDA4343);
  static const red600 = Color(0xFFAE3636);
  static const red700 = Color(0xFF842828);

  // ── Green ──
  static const green50 = Color(0xFFF1FAF3);
  static const green100 = Color(0xFFE3F6E7);
  static const green200 = Color(0xFFBFEAC9);
  static const green300 = Color(0xFF95DCA5);
  static const green400 = Color(0xFF71D186);
  static const green500 = Color(0xFF4EC568);
  static const green600 = Color(0xFF3E9E53);
  static const green700 = Color(0xFF2F773F);

  // ── Yellow (Warning) ──
  static const yellow50 = Color(0xFFFDF8F0);
  static const yellow100 = Color(0xFFFBF1E1);
  static const yellow200 = Color(0xFFF7DEB9);
  static const yellow300 = Color(0xFFF1C98B);
  static const yellow400 = Color(0xFFEDB664);
  static const yellow500 = Color(0xFFE8A43D);
  static const yellow600 = Color(0xFFBA8331);
  static const yellow700 = Color(0xFF8C6325);

  // ── Purple (Highlight) ──
  static const purple50 = Color(0xFFF5F3FF);
  static const purple100 = Color(0xFFEDE9FE);
  static const purple200 = Color(0xFFDDD6FE);
  static const purple300 = Color(0xFFC4B5FD);
  static const purple400 = Color(0xFFA78BFA);
  static const purple500 = Color(0xFF8B5CF6);
  static const purple600 = Color(0xFF7C3AED);
  static const purple700 = Color(0xFF6D28D9);

  // ── Semantic aliases ──
  static const brand = primary500;
  static const brandHover = primary600;
  static const error = red500;
  static const success = green500;
  static const warning = yellow500;
  static const info = primary500;
  static const highlight = purple600;

  // ── Text ──
  static const textStrong = gray900;     // --text-default-strong
  static const textNormal = gray700;     // --text-default-normal
  static const textWeak = gray600;       // --text-default-weak
  static const textWeaker = gray500;     // --text-default-weaker
  static const textBrand = primary500;
  static const textDanger = red500;
  static const textPositive = green600;
  static const textWarning = yellow500;
  static const textHighlight = purple600;

  // ── Background ──
  static const bgDefault = Color(0xFFFFFFFF);
  static const bgDifferentiate = gray50;
  static const bgHover = gray100;
  static const bgPressed = gray200;
  static const bgStrong = gray100;
  static const bgStronger = gray200;
  static const bgBlack = gray800;
  static const bgBrandWeaker = primary50;
  static const bgBrandWeak = primary100;
  static const bgBrandNormal = primary500;
  static const bgDangerWeaker = red50;
  static const bgDangerWeak = red100;
  static const bgPositiveWeaker = green50;
  static const bgPositiveWeak = green100;
  static const bgWarningWeaker = yellow50;
  static const bgWarningWeak = yellow100;
  static const bgHighlightWeaker = purple50;
  static const bgHighlightWeak = purple100;

  // ── Border ──
  static const borderWeaker = gray300;
  static const borderWeak = gray400;
  static const borderNormal = gray500;
  static const borderBrand = primary500;
  static const borderDanger = red500;

  // ── Chart Colors (from theme.ts) ──
  static const chartColors = [
    Color(0xFFDE3D82), // Pink
    Color(0xFFF68511), // Orange
    Color(0xFF0FB5AE), // Teal
    Color(0xFF0549CC), // Primary Blue
    Color(0xFFE76296), // Lighter Pink
  ];

  static const chartColorsAll = [
    Color(0xFFDE3D82), Color(0xFFF68511), Color(0xFF0FB5AE), Color(0xFF0549CC),
    Color(0xFFE76296), Color(0xFFFB963E), Color(0xFF46C0BA), Color(0xFF6A93E1),
    Color(0xFFEE81AA), Color(0xFFFEA860), Color(0xFF8BA6E6), Color(0xFF66CCC5),
    Color(0xFFF59DBD), Color(0xFFFFB980), Color(0xFF81D7D1), Color(0xFFC3CDEE),
    Color(0xFFFAB9D1), Color(0xFFFFCAA0), Color(0xFF9AE3DD), Color(0xFFDDE2F2),
  ];

  // ── ThemeData ──
  static ThemeData get theme => ThemeData(
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: bgDefault,
    colorScheme: ColorScheme.light(
      primary: brand,
      onPrimary: Colors.white,
      surface: bgDefault,
      onSurface: textStrong,
      error: error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: textStrong,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textStrong,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: gray200,
      thickness: 1,
      space: 0,
    ),
    textTheme: const TextTheme(
      // titleLarge → subtitleLargeBold (18px, w700, lh 1.4)
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textStrong, height: 1.4),
      headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textStrong, height: 1.4),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textStrong, height: 1.4),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textStrong, height: 1.4),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textStrong, height: 1.28),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textNormal, height: 1.6),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textNormal, height: 1.6),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textWeak, height: 1.6),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textStrong, height: 1.28),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textWeak, height: 1.28),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: textWeaker, height: 1.36),
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
    color: gray900.withValues(alpha: 0.04),
    blurRadius: 2,
    offset: const Offset(0, 1),
  );

  static BoxShadow get shadow => BoxShadow(
    color: gray900.withValues(alpha: 0.06),
    blurRadius: 3,
    offset: const Offset(0, 1),
  );

  static BoxShadow get shadowMd => BoxShadow(
    color: gray900.withValues(alpha: 0.06),
    blurRadius: 6,
    offset: const Offset(0, 4),
  );
}
