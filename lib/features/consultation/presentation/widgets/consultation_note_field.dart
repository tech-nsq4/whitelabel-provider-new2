import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';

/// A labelled multi-line text area on the consultation "الكشف" tab — the
/// complaint, diagnosis and the visit / medication / tests notes all share
/// this layout.
class ConsultationNoteField extends StatelessWidget {
  const ConsultationNoteField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 3,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondaryColor.themeColor),
        8.height,
        CustomTextField(
          controller: controller,
          hint: '',
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }
}
