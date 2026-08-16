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
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_toggle_chip.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/calendar_day_load_model.dart';
import '../logic/calendar_cubit.dart';
import 'widgets/add_appointment_sheet.dart';
import 'widgets/calendar_day_cell.dart';
import 'widgets/calendar_legend.dart';
import 'widgets/calendar_slot_row.dart';

const _kMonthKeys = [
  LocaleKeys.calendarScreen_month1,
  LocaleKeys.calendarScreen_month2,
  LocaleKeys.calendarScreen_month3,
  LocaleKeys.calendarScreen_month4,
  LocaleKeys.calendarScreen_month5,
  LocaleKeys.calendarScreen_month6,
  LocaleKeys.calendarScreen_month7,
  LocaleKeys.calendarScreen_month8,
  LocaleKeys.calendarScreen_month9,
  LocaleKeys.calendarScreen_month10,
  LocaleKeys.calendarScreen_month11,
  LocaleKeys.calendarScreen_month12,
];

const _kWeekdayKeys = [
  LocaleKeys.calendarScreen_wdSun,
  LocaleKeys.calendarScreen_wdMon,
  LocaleKeys.calendarScreen_wdTue,
  LocaleKeys.calendarScreen_wdWed,
  LocaleKeys.calendarScreen_wdThu,
  LocaleKeys.calendarScreen_wdFri,
  LocaleKeys.calendarScreen_wdSat,
];

const _kDoctorFilters = ['all', 'د. خالد', 'د. رهف', 'د. سارة'];

/// "التقويم" — month grid with per-day booking load, plus the selected
/// day's slot list.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final _cubit = getIt<CalendarCubit>()..load();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openAddAppointment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddAppointmentSheet(
        onSubmit: (name, service, price) {
          AppOverlay.showSuccess(
            LocaleKeys.appt_success.tr(namedArgs: {'name': name, 'service': service}),
          );
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
        child: BlocBuilder<CalendarCubit, CalendarState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is CalendarLoading || state is CalendarInitial,
              error: state is CalendarError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final data = (state as CalendarSuccess).data;
                final daysInMonth = DateTime(data.month.year, data.month.month + 1, 0).day;
                final leadingBlanks = data.month.weekday % 7;

                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.calendarScreen_title.tr(),
                      eyebrow: LocaleKeys.calendarScreen_subtitle.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                      trailing: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.plus,
                        color: AppColors.primaryColor.themeColor,
                        onTap: _openAddAppointment,
                      ),
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            AppHeaderIconButton(
                              svgIcon: AppSvgIcons.chevronRow,
                              size: 34,
                              onTap: () => _cubit.changeMonth(-1),
                            ),
                            8.width,
                            AppHeaderIconButton(
                              svgIcon: AppSvgIcons.chevronBack,
                              size: 34,
                              onTap: () => _cubit.changeMonth(1),
                            ),
                          ],
                        ),
                        AppText(
                          '${_kMonthKeys[data.month.month - 1].tr()} ${data.month.year}',
                          isHeading: true,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor,
                        ),
                      ],
                    ),
                    14.height,
                    SizedBox(
                      height: 34.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (final filter in _kDoctorFilters)
                            Padding(
                              padding: EdgeInsetsDirectional.only(start: 7.w),
                              child: AppToggleChip(
                                label: filter == 'all' ? LocaleKeys.calendarScreen_filterAll.tr() : filter,
                                selected: data.doctorFilter == filter,
                                onTap: () => _cubit.setDoctorFilter(filter),
                              ),
                            ),
                        ],
                      ),
                    ),
                    16.height,
                    Row(
                      children: [
                        for (final wd in _kWeekdayKeys)
                          Expanded(
                            child: AppText(wd.tr(),
                                textAlign: TextAlign.center,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.mutedColor.themeColor),
                          ),
                      ],
                    ),
                    6.height,
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: daysInMonth + leadingBlanks,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        if (index < leadingBlanks) return const SizedBox.shrink();
                        final day = index - leadingBlanks + 1;
                        CalendarDayLoadModel? load;
                        for (final l in data.monthLoad) {
                          if (l.day == day) {
                            load = l;
                            break;
                          }
                        }
                        final date = DateTime(data.month.year, data.month.month, day);
                        return CalendarDayCell(
                          day: day,
                          load: load,
                          isSelected: data.selectedDay.year == date.year &&
                              data.selectedDay.month == date.month &&
                              data.selectedDay.day == date.day,
                          onTap: () => _cubit.selectDay(date),
                        );
                      },
                    ),
                    14.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CalendarLegend(color: AppColors.primaryColor.themeColor,
                            label: LocaleKeys.calendarScreen_legendLight.tr()),
                        16.width,
                        CalendarLegend(color: AppColors.warningColor.themeColor,
                            label: LocaleKeys.calendarScreen_legendMedium.tr()),
                        16.width,
                        CalendarLegend(color: AppColors.errorColor.themeColor,
                            label: LocaleKeys.calendarScreen_legendBusy.tr()),
                      ],
                    ),
                    18.height,
                    AppText(
                      LocaleKeys.calendarScreen_dayCount.tr(namedArgs: {
                        'count': '${data.daySlots.where((s) => !s.isAvailable).length}',
                        'available': '${data.daySlots.where((s) => s.isAvailable).length}',
                      }),
                      fontSize: 11,
                      color: AppColors.mutedColor.themeColor,
                    ),
                    10.height,
                    AppCard(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          for (var i = 0; i < data.daySlots.length; i++)
                            CalendarSlotRow(
                              slot: data.daySlots[i],
                              showDivider: i < data.daySlots.length - 1,
                              onTap: () {
                                if (data.daySlots[i].isAvailable) _openAddAppointment();
                              },
                            ),
                        ],
                      ),
                    ),
                    16.height,
                    CustomButton(
                      onTap: _openAddAppointment,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppSvgIcon(AppSvgIcons.plus, size: 16.sp, color: Colors.white),
                          7.width,
                          Text(LocaleKeys.calendarScreen_addAppointment.tr(),
                              style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ],
                      ),
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
