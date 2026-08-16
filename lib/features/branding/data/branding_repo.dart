import 'package:flutter/material.dart';

import 'models/branding_theme_option.dart';

/// TODO(api): mock data until `ApiEndpoints.branding` exists.
class BrandingRepo {
  static const themes = [
    BrandingThemeOption(
      id: 'emerald',
      name: 'الزمردي',
      brand: Color(0xFF0F6B5C),
      paper: Color(0xFFF6F4EF),
      ink: Color(0xFF0A1F1B),
      gold: Color(0xFFC9A227),
    ),
    BrandingThemeOption(
      id: 'royal_blue',
      name: 'الأزرق الملكي',
      brand: Color(0xFF1A56DB),
      paper: Color(0xFFF0F4FF),
      ink: Color(0xFF0F1C3F),
      gold: Color(0xFFF59E0B),
    ),
    BrandingThemeOption(
      id: 'burgundy',
      name: 'برجاندي',
      brand: Color(0xFF8B1A36),
      paper: Color(0xFFFDF5F6),
      ink: Color(0xFF1A0509),
      gold: Color(0xFFC9A227),
    ),
    BrandingThemeOption(
      id: 'violet',
      name: 'الأرجواني',
      brand: Color(0xFF5B21B6),
      paper: Color(0xFFF5F3FF),
      ink: Color(0xFF1E1245),
      gold: Color(0xFFF59E0B),
    ),
    BrandingThemeOption(
      id: 'slate',
      name: 'الرمادي الأنيق',
      brand: Color(0xFF374151),
      paper: Color(0xFFF9FAFB),
      ink: Color(0xFF111827),
      gold: Color(0xFFD97706),
    ),
    BrandingThemeOption(
      id: 'teal',
      name: 'الفيروزي',
      brand: Color(0xFF0E7490),
      paper: Color(0xFFF0FAFA),
      ink: Color(0xFF0C2A36),
      gold: Color(0xFFD97706),
    ),
    BrandingThemeOption(
      id: 'rose',
      name: 'الوردي الداكن',
      brand: Color(0xFF9D174D),
      paper: Color(0xFFFFF0F6),
      ink: Color(0xFF2D0516),
      gold: Color(0xFFF59E0B),
    ),
    BrandingThemeOption(
      id: 'noir',
      name: 'الأسود الفاخر',
      brand: Color(0xFF1C1C1E),
      paper: Color(0xFFF5F5F7),
      ink: Color(0xFF000000),
      gold: Color(0xFFC9A227),
    ),
  ];

  Future<List<BrandingThemeOption>> getThemes() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return themes;
  }
}
