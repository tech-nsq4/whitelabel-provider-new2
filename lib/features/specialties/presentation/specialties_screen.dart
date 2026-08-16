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
import '../data/models/specialty_model.dart';
import '../logic/specialties_cubit.dart';
import 'widgets/specialty_edit_sheet.dart';
import 'widgets/specialty_tile.dart';

/// "التخصصات" — one specialty per row, shared across every branch.
class SpecialtiesScreen extends StatefulWidget {
  const SpecialtiesScreen({super.key});

  @override
  State<SpecialtiesScreen> createState() => _SpecialtiesScreenState();
}

class _SpecialtiesScreenState extends State<SpecialtiesScreen> {
  late final _cubit = getIt<SpecialtiesCubit>()..loadSpecialties();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openEdit([SpecialtyModel? existing]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpecialtyEditSheet(
        existing: existing,
        onSubmit: (model) {
          _cubit.upsert(model);
          AppOverlay.showSuccess((existing == null
                  ? LocaleKeys.specialtySheet_successAdd
                  : LocaleKeys.specialtySheet_successEdit)
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
        child: BlocBuilder<SpecialtiesCubit, SpecialtiesState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is SpecialtiesLoading || state is SpecialtiesInitial,
              error: state is SpecialtiesError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final specialties = (state as SpecialtiesSuccess).specialties;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.specialtiesScreen_title.tr(),
                      eyebrow: LocaleKeys.specialtiesScreen_subtitle.tr(),
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
                            child: AppText(LocaleKeys.specialtiesScreen_infoBanner.tr(),
                                fontSize: 11,
                                height: 1.7,
                                color: AppColors.textSecondaryColor.themeColor),
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    for (final specialty in specialties)
                      SpecialtyTile(specialty: specialty, onEdit: () => _openEdit(specialty)),
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
