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
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/policy_cubit.dart';
import 'widgets/policy_toggle_row.dart';

/// "سياسة الحجز" — cancellation/reschedule, reminder and payment toggles.
class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  late final _cubit = getIt<PolicyCubit>()..loadSettings();

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
        child: BlocBuilder<PolicyCubit, PolicyState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is PolicyLoading || state is PolicyInitial,
              error: state is PolicyError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final settings = (state as PolicySuccess).settings;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.policyScreen_title.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    18.height,
                    AppSectionTitle(LocaleKeys.policyScreen_cancelSection.tr()),
                    10.height,
                    AppCard(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          PolicyToggleRow(
                            title: LocaleKeys.policyScreen_allowCancel.tr(),
                            subtitle: LocaleKeys.policyScreen_allowCancelSub.tr(),
                            value: settings.allowCancellation,
                            onChanged: (_) => _cubit.toggleCancellation(),
                          ),
                          PolicyToggleRow(
                            title: LocaleKeys.policyScreen_allowReschedule.tr(),
                            subtitle: LocaleKeys.policyScreen_allowRescheduleSub.tr(),
                            value: settings.allowReschedule,
                            onChanged: (_) => _cubit.toggleReschedule(),
                          ),
                          PolicyToggleRow(
                            title: LocaleKeys.policyScreen_autoRefund.tr(),
                            subtitle: LocaleKeys.policyScreen_autoRefundSub.tr(),
                            value: settings.autoRefund,
                            onChanged: (_) => _cubit.toggleAutoRefund(),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    22.height,
                    AppSectionTitle(LocaleKeys.policyScreen_reminderSection.tr()),
                    10.height,
                    AppCard(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          PolicyToggleRow(
                            title: LocaleKeys.policyScreen_reminderDay.tr(),
                            subtitle: LocaleKeys.policyScreen_reminderDaySub.tr(),
                            value: settings.reminderDayBefore,
                            onChanged: (_) => _cubit.toggleReminderDayBefore(),
                          ),
                          PolicyToggleRow(
                            title: LocaleKeys.policyScreen_reminderHour.tr(),
                            subtitle: LocaleKeys.policyScreen_reminderHourSub.tr(),
                            value: settings.reminderHourBefore,
                            onChanged: (_) => _cubit.toggleReminderHourBefore(),
                          ),
                          PolicyToggleRow(
                            title: LocaleKeys.policyScreen_checkin.tr(),
                            subtitle: LocaleKeys.policyScreen_checkinSub.tr(),
                            value: settings.checkinRequest,
                            onChanged: (_) => _cubit.toggleCheckinRequest(),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    22.height,
                    AppSectionTitle(LocaleKeys.policyScreen_paymentSection.tr()),
                    10.height,
                    AppCard(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: PolicyToggleRow(
                        title: LocaleKeys.policyScreen_videoPrepayment.tr(),
                        subtitle: LocaleKeys.policyScreen_videoPrepaymentSub.tr(),
                        value: settings.videoPrepayment,
                        onChanged: (_) => _cubit.toggleVideoPrepayment(),
                        showDivider: false,
                      ),
                    ),
                    22.height,
                    CustomButton(
                      onTap: () {
                        _cubit.save();
                        AppOverlay.showSuccess(LocaleKeys.policyScreen_saveSuccess.tr());
                      },
                      title: LocaleKeys.common_confirm.tr(),
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
