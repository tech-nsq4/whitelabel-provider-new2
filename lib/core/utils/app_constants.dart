import 'package:google_fonts/google_fonts.dart';
import 'package:white_label_provider/features/auth/data/models/manager_model.dart';

class AppConstants {
  AppConstants._();

  // ─── App ──────────────────────────────────────────────────────────────────
  static const String appName = 'White Label Provider';

  // ─── Pagination ───────────────────────────────────────────────────────────
  static const int pageSize = 15;
  static const int firstPage = 1;

  // ─── Animation ────────────────────────────────────────────────────────────
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  // ─── UI ───────────────────────────────────────────────────────────────────
  static const double defaultBorderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
}

class AppFonts {
  AppFonts._();

  /// Body text — IBM Plex Sans Arabic.
  static String get bodyFont => GoogleFonts.ibmPlexSansArabic().fontFamily!;

  /// Headings, numbers, buttons — Readex Pro.
  static String get headingFont => GoogleFonts.readexPro().fontFamily!;
}

/// The currently authenticated clinic manager. `null` before login (or once
/// a session goes stale) — every screen behind [Routes.layoutScreen] expects
/// this to be set, since there's no guest mode for a staff-only app.
ManagerModel? kUserModel;

/// Returns `true` when no manager is signed in.
bool get kIsGuest => kUserModel == null;
