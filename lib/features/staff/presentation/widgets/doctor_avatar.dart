import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../data/models/doctor_profile_model.dart';

/// The doctor's photo as a rounded square, falling back to the initials
/// avatar when the API returns no image.
class DoctorAvatar extends StatelessWidget {
  const DoctorAvatar(this.doctor, {super.key, this.size = 52, this.filled = false});

  final DoctorProfileModel doctor;
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final image = doctor.image;
    if (image == null || image.isEmpty) {
      return AppInitialsAvatar(doctor.initial, size: size, filled: filled);
    }
    return CustomImage(
      image: image,
      width: size.r,
      height: size.r,
      radius: (size * 0.31).r,
    );
  }
}
