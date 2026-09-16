import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/image/custom_image.dart';

class OnboardingImage extends StatelessWidget {
  const OnboardingImage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomImage(
        image: url,
        width: 260.w,
        height: 260.w,
        radius: 28,
        fit: BoxFit.cover,
      ),
    );
  }
}
