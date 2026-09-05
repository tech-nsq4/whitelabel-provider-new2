import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_toggle_chip.dart';
import '../../data/models/consultation_option.dart';

/// A pick-list of lab / imaging options rendered as toggle chips, under a
/// small section sub-label.
class ConsultationOptionsSection extends StatelessWidget {
  const ConsultationOptionsSection({
    super.key,
    required this.label,
    required this.options,
    required this.selectedIds,
    required this.onToggle,
  });

  final String label;
  final List<ConsultationOption> options;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondaryColor.themeColor),
        10.height,
        Wrap(
          spacing: 7.w,
          runSpacing: 7.h,
          children: [
            for (final option in options)
              AppToggleChip(
                label: option.price != null
                    ? '${option.label} · ${option.price!.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}'
                    : option.label,
                selected: selectedIds.contains(option.id),
                onTap: () => onToggle(option.id),
              ),
          ],
        ),
      ],
    );
  }
}
