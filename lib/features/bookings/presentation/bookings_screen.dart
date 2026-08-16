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
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/app_segmented_tabs.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../calendar/presentation/widgets/add_appointment_sheet.dart';
import '../data/models/booking_model.dart';
import '../logic/bookings_cubit.dart';
import 'widgets/booking_card.dart';

/// "الحجوزات" — every booking made through the patient app, grouped by day.
class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  late final _cubit = getIt<BookingsCubit>()..loadBookings();
  int _tabIndex = 0;

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
        onSubmit: (name, service, price) => AppOverlay.showSuccess(
          LocaleKeys.appt_success.tr(namedArgs: {'name': name, 'service': service}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<BookingsCubit, BookingsState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is BookingsLoading || state is BookingsInitial,
              error: state is BookingsError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final all = (state as BookingsSuccess).bookings;
                final filtered = switch (_tabIndex) {
                  1 => all.where((b) => b.status == BookingStatus.pendingPayment).toList(),
                  2 => all.where((b) => b.status != BookingStatus.pendingPayment).toList(),
                  _ => all,
                };
                final today = filtered.where((b) => b.dayGroup == BookingDayGroup.today).toList();
                final tomorrow =
                    filtered.where((b) => b.dayGroup == BookingDayGroup.tomorrow).toList();

                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.bookings_title.tr(),
                      eyebrow: LocaleKeys.bookings_subtitle
                          .tr(namedArgs: {'count': '${all.length}'}),
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
                    AppSegmentedTabs(
                      labels: [
                        LocaleKeys.bookings_tabAll.tr(),
                        LocaleKeys.bookings_tabPending.tr(),
                        LocaleKeys.bookings_tabConfirmed.tr(),
                      ],
                      selectedIndex: _tabIndex,
                      onChanged: (i) => setState(() => _tabIndex = i),
                    ),
                    16.height,
                    if (today.isNotEmpty) ...[
                      AppSectionTitle(LocaleKeys.bookings_todaySection.tr()),
                      10.height,
                      for (final b in today) BookingCard(booking: b, onSendPaymentLink: () => _sendLink(b)),
                    ],
                    if (tomorrow.isNotEmpty) ...[
                      if (today.isNotEmpty) 8.height,
                      AppSectionTitle(LocaleKeys.bookings_tomorrowSection.tr()),
                      10.height,
                      for (final b in tomorrow) BookingCard(booking: b, onSendPaymentLink: () => _sendLink(b)),
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

  void _sendLink(BookingModel booking) {
    AppOverlay.showSuccess(
      LocaleKeys.bookings_paymentLinkSent.tr(namedArgs: {'name': booking.patientName}),
    );
  }
}
