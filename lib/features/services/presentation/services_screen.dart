import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/services_cubit.dart';
import 'widgets/service_card.dart';

/// "الخدمات" — a read-only directory of the clinic's services.
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late final _cubit = getIt<ServicesCubit>()..loadServices();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ServicesCubit, ServicesState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              onRefresh: () async => _cubit.loadServices(),
              isLoading: state is ServicesLoading || state is ServicesInitial,
              error: state is ServicesError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              onRetry: () => _cubit.loadServices(),
              builder: (context) {
                final services = (state as ServicesSuccess).services;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.servicesScreen_title.tr(),
                      eyebrow: LocaleKeys.servicesScreen_subtitle.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    16.height,
                    for (final service in services) ServiceCard(service: service),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
