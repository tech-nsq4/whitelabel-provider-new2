import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/app_svg_icons.dart';
import '../utils/locale_keys.dart';
import 'app_svg_icon.dart';
import 'app_text.dart';

/// "حجزه يحيى" — shown above a family-booked record's primary name (a
/// queue patient, a test request, ...) so staff don't mistake the
/// booking account holder for who the record is actually for. Shared
/// across features; renders nothing when there's no family booking.
class BookedByCaption extends StatelessWidget {
  const BookedByCaption({super.key, required this.bookedByName});

  final String? bookedByName;

  @override
  Widget build(BuildContext context) {
    final name = bookedByName;
    if (name == null || name.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSvgIcon(AppSvgIcons.family, size: 11.sp, color: AppColors.secondaryColor.themeColor),
          4.width,
          AppText(
            LocaleKeys.common_bookedByValue.tr(namedArgs: {'name': name}),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryColor.themeColor,
          ),
        ],
      ),
    );
  }
}
