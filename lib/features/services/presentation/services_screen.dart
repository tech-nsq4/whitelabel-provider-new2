import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/service_model.dart';
import '../logic/services_cubit.dart';
import 'widgets/service_card.dart';
import 'widgets/service_edit_sheet.dart';

/// "الخدمات" — every service the clinic offers, its per-mode pricing, and
/// whether it's currently visible to patients.
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

  void _openEdit([ServiceModel? existing]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ServiceEditSheet(
        existing: existing,
        onSubmit: (model) {
          _cubit.upsert(model);
          AppOverlay.showSuccess((existing == null
                  ? LocaleKeys.serviceSheet_successAdd
                  : LocaleKeys.serviceSheet_successEdit)
              .tr(namedArgs: {'name': model.name}));
        },
      ),
    );
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
              isLoading: state is ServicesLoading || state is ServicesInitial,
              error: state is ServicesError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
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
                      trailing: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.plus,
                        color: AppColors.primaryColor.themeColor,
                        onTap: () => _openEdit(),
                      ),
                    ),
                    16.height,
                    AppCard(
                      color: AppColors.surfaceColor.themeColor,
                      borderColor: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSvgIcon(AppSvgIcons.info,
                              size: 17.sp, color: AppColors.primaryColor.themeColor),
                          11.width,
                          Expanded(
                            child: AppText(LocaleKeys.servicesScreen_infoBanner.tr(),
                                fontSize: 11,
                                height: 1.7,
                                color: AppColors.textSecondaryColor.themeColor),
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    for (final service in services)
                      ServiceCard(
                        service: service,
                        onToggle: () => _cubit.toggle(service.id),
                        onEdit: () => _openEdit(service),
                        onDelete: () =>
                            AppOverlay.showSuccess(LocaleKeys.servicesScreen_deleteToast.tr(
                          namedArgs: {'name': service.name},
                        )),
                      ),
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
