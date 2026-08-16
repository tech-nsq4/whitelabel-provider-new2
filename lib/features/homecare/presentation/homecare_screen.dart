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
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/homecare_cubit.dart';
import 'widgets/homecare_request_card.dart';
import 'widgets/homecare_stat_tile.dart';

/// "الرعاية المنزلية" — home-visit requests waiting to be assigned to a
/// doctor, plus the ones already on their way.
class HomecareScreen extends StatefulWidget {
  const HomecareScreen({super.key});

  @override
  State<HomecareScreen> createState() => _HomecareScreenState();
}

class _HomecareScreenState extends State<HomecareScreen> {
  late final _cubit = getIt<HomecareCubit>()..loadRequests();

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
        child: BlocBuilder<HomecareCubit, HomecareState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is HomecareLoading || state is HomecareInitial,
              error: state is HomecareError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final all = (state as HomecareSuccess).requests;
                final pending = all.where((r) => !r.isAssigned).toList();
                final assigned = all.where((r) => r.isAssigned).toList();

                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.homecareScreen_title.tr(),
                      eyebrow: LocaleKeys.homecareScreen_subtitle.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    16.height,
                    AppCard(
                      color: AppColors.surfaceColor.themeColor,
                      borderColor: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSvgIcon(AppSvgIcons.home2,
                              size: 17.sp, color: AppColors.primaryColor.themeColor),
                          11.width,
                          Expanded(
                            child: AppText(LocaleKeys.homecareScreen_infoBanner.tr(),
                                fontSize: 11,
                                height: 1.7,
                                color: AppColors.textSecondaryColor.themeColor),
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    Row(
                      children: [
                        HomecareStatTile(
                          value: '${pending.length}',
                          label: LocaleKeys.homecareScreen_statPending.tr(),
                          color: AppColors.warningColor.themeColor,
                        ),
                        HomecareStatTile(
                          value: '2',
                          label: LocaleKeys.homecareScreen_statAvailable.tr(),
                          color: AppColors.primaryColor.themeColor,
                        ),
                        HomecareStatTile(
                          value: '7/12',
                          label: LocaleKeys.homecareScreen_statCapacity.tr(),
                        ),
                      ],
                    ),
                    18.height,
                    if (pending.isNotEmpty) ...[
                      AppSectionTitle(LocaleKeys.homecareScreen_pendingSection.tr()),
                      10.height,
                      for (final r in pending)
                        HomecareRequestCard(request: r, onAssign: () => _assign(r.id)),
                    ],
                    if (assigned.isNotEmpty) ...[
                      14.height,
                      AppSectionTitle(LocaleKeys.homecareScreen_assignedSection.tr()),
                      10.height,
                      for (final r in assigned) HomecareRequestCard(request: r, onAssign: () {}),
                    ],
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _assign(String id) {
    _cubit.assign(id);
    AppOverlay.showSuccess(LocaleKeys.homecareScreen_assignSuccess.tr());
  }
}
