import 'package:viva_connect_provider/app/router/navigation_services.dart';
import 'package:flutter/material.dart';

class ColorModel {
  final Color lightColor;
  final Color darkColor;

  const ColorModel({required this.lightColor, required this.darkColor});

  Color get light => lightColor;
  Color get dark => darkColor;
}

extension ColorTheme on ColorModel {
  Color get themeColor {
    final context = NavigationService.navigationKey.currentContext;
    if (context != null && Theme.of(context).brightness == Brightness.dark) {
      return darkColor;
    } else {
      return lightColor;
    }
  }
}

class AppColors {
  AppColors._();

  // ─── Brand ──────────────────────────────────────────────────────────────
  static const ColorModel primaryColor = ColorModel(
    lightColor: Color(0xFF113C7A),
    darkColor: Color(0xFF5388BA),
  );

  static const ColorModel primaryLightColor = ColorModel(
    lightColor: Color(0xFF5388BA),
    darkColor: Color(0xFF5388BA),
  );

  static const ColorModel primaryDarkColor = ColorModel(
    lightColor: Color(0xFF174882),
    darkColor: Color(0xFF174882),
  );

  static const ColorModel secondaryColor = ColorModel(
    lightColor: Color(0xFF00A0A1),
    darkColor: Color(0xFF00A0A1),
  );

  // ─── Brand gradient stops ───────────────────────────────────────────────
  static const ColorModel blueGradientStart = ColorModel(
    lightColor: Color(0xFF174882),
    darkColor: Color(0xFF174882),
  );

  static const ColorModel blueGradientEnd = ColorModel(
    lightColor: Color(0xFF5388BA),
    darkColor: Color(0xFF5388BA),
  );

  static const ColorModel turquoiseGradientStart = ColorModel(
    lightColor: Color(0xFF00A1A1),
    darkColor: Color(0xFF00A1A1),
  );

  static const ColorModel turquoiseGradientEnd = ColorModel(
    lightColor: Color(0xFF006A6A),
    darkColor: Color(0xFF006A6A),
  );

  // ─── Surfaces ────────────────────────────────────────────────────────────
  static const ColorModel backgroundColor = ColorModel(
    lightColor: Color(0xFFF6F4EF),
    darkColor: Color(0xff121212),
  );

  static const ColorModel surfaceColor = ColorModel(
    lightColor: Color(0xFFEFEBE1),
    darkColor: Color(0xff1E1E1E),
  );

  static const ColorModel cardColor = ColorModel(
    lightColor: Color(0xFFFFFFFF),
    darkColor: Color(0xff2C2C2C),
  );

  static const ColorModel dividerColor = ColorModel(
    lightColor: Color(0xFFE7E3DA),
    darkColor: Color(0xff424242),
  );

  // ─── Text ────────────────────────────────────────────────────────────────
  static const ColorModel textPrimaryColor = ColorModel(
    lightColor: Color(0xFF0A1F1B),
    darkColor: Color(0xffFFFFFF),
  );

  static const ColorModel textSecondaryColor = ColorModel(
    lightColor: Color(0xFF41544F),
    darkColor: Color(0xffB0B0B0),
  );

  /// Muted text — captions, placeholders, disabled labels.
  static const ColorModel mutedColor = ColorModel(
    lightColor: Color(0xFF7C8B87),
    darkColor: Color(0xFF8A9490),
  );

  static const ColorModel hintColor = ColorModel(
    lightColor: Color(0xFFB4BFBC),
    darkColor: Color(0xff616161),
  );

  // ─── Status ──────────────────────────────────────────────────────────────
  static const ColorModel errorColor = ColorModel(
    lightColor: Color(0xFFB3402F),
    darkColor: Color(0xFFEF5350),
  );

  static const ColorModel successColor = ColorModel(
    lightColor: Color(0xFF0F6B5C),
    darkColor: Color(0xFF1A8B77),
  );

  static const ColorModel warningColor = ColorModel(
    lightColor: Color(0xFFA97612),
    darkColor: Color(0xFFA97612),
  );

  /// Golden accent — CTA highlights, ratings, decorative details.
  static const ColorModel accentGold = ColorModel(
    lightColor: Color(0xFFC9A227),
    darkColor: Color(0xFFC9A227),
  );

  // ─── Status chip backgrounds ─────────────────────────────────────────────
  /// Tinted background behind [warningColor] text — "قيد الانتظار" /
  /// "بانتظار الدفع" style chips and banners.
  static const ColorModel warningBgColor = ColorModel(
    lightColor: Color(0xFFFDF3E3),
    darkColor: Color(0xFFFDF3E3),
  );

  /// Tinted background behind [errorColor] text — "حرج" / allergy-alert
  /// style chips and banners.
  static const ColorModel criticalBgColor = ColorModel(
    lightColor: Color(0xFFFBEDEA),
    darkColor: Color(0xFFFBEDEA),
  );
}

class AppGradients {
  AppGradients._();

  static LinearGradient get blue => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.blueGradientStart.themeColor,
          AppColors.blueGradientEnd.themeColor,
        ],
      );

  static LinearGradient get turquoise => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.turquoiseGradientStart.themeColor,
          AppColors.turquoiseGradientEnd.themeColor,
        ],
      );
}
