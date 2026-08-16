import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_toggle_chip.dart';
import '../../data/models/consultation_option.dart';

class ConsultationOptionsSection extends StatelessWidget {
  const ConsultationOptionsSection({
    super.key,
    required this.label,
    this.hint,
    required this.options,
    required this.selectedIds,
    required this.onToggle,
  });

  final String label;
  final String? hint;
  final List<ConsultationOption> options;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.mutedColor.themeColor),
        if (hint != null) ...[
          4.height,
          AppText(hint!,
              fontSize: 10.5, color: AppColors.mutedColor.themeColor),
        ],
        9.height,
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
