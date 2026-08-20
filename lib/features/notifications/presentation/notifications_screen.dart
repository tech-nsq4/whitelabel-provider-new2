import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/notifications_cubit.dart';
import 'widgets/notification_tile.dart';

/// "الإشعارات" — booking-lifecycle events (booked/accepted/started/
/// completed).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _markingAllRead = false;

  @override
  void initState() {
    super.initState();
    final cubit = getIt<NotificationsCubit>();
    if (cubit.state is NotificationsInitial) cubit.loadNotifications();
  }

  Future<void> _markAllRead() async {
    setState(() => _markingAllRead = true);
    await getIt<NotificationsCubit>().markAllAsRead();
    if (mounted) setState(() => _markingAllRead = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          bloc: getIt<NotificationsCubit>(),
          builder: (context, state) {
            return CustomScreenStateLayout(
              onRefresh: () async => getIt<NotificationsCubit>().loadNotifications(),
              isLoading:
                  state is NotificationsLoading || state is NotificationsInitial,
              error: state is NotificationsError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              onRetry: () => getIt<NotificationsCubit>().loadNotifications(),
              isEmpty:
                  state is NotificationsSuccess && state.notifications.isEmpty,
              noDataBuilder: (context) => Center(
                child: AppText(LocaleKeys.notifications_empty.tr(),
                    fontSize: 12.5, color: AppColors.mutedColor.themeColor),
              ),
              builder: (context) {
                final notifications = (state as NotificationsSuccess).notifications;
                final hasUnread = notifications.any((n) => !n.isRead);
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.notifications_title.tr(),
                      eyebrow: LocaleKeys.notifications_subtitle.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                      trailing: hasUnread
                          ? CustomButton(
                              onTap: _markAllRead,
                              title: LocaleKeys.notifications_markAllRead.tr(),
                              loading: _markingAllRead,
                              width: 108.w,
                              height: 34.h,
                              radius: 10,
                              fontSize: 10.5,
                              color: AppColors.surfaceColor.themeColor,
                              textColor: AppColors.primaryColor.themeColor,
                            )
                          : null,
                    ),
                    16.height,
                    for (final notification in notifications)
                      NotificationTile(
                        notification: notification,
                        onTap: () => getIt<NotificationsCubit>()
                            .markAsRead(notification.id),
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
