import 'package:flutter/material.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import 'app_text.dart';

/// The small eyebrow + big Readex-Pro title pair every screen in this app
/// opens with (`.eyebrow` + `.d2` in the reference design), with an
/// optional [leading] back button and [trailing] action.
class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.leading,
    this.trailing,
  });

  final String title;
  final String? eyebrow;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[leading!, 12.width],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null) ...[
                AppText(
                  eyebrow!,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedColor.themeColor,
                ),
                3.height,
              ],
              AppText(
                title,
                isHeading: true,
                fontSize: leading != null ? 17 : 19,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor,
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
