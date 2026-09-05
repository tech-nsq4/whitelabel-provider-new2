import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_profile_model.dart';

/// One specialization (or sub-specialization) on the doctor details
/// screen — its title with the optional description underneath.
class DoctorSpecializationTile extends StatelessWidget {
  const DoctorSpecializationTile({super.key, required this.specialization});

  final DoctorSpecialization specialization;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: 8.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(specialization.title,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          if (specialization.description != null &&
              specialization.description!.isNotEmpty) ...[
            4.height,
            AppText(specialization.description!,
                fontSize: 11,
                height: 1.5,
                color: AppColors.textSecondaryColor.themeColor),
          ],
        ],
      ),
    );
  }
}
