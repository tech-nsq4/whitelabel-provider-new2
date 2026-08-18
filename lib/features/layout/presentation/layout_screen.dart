import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../calendar/presentation/widgets/add_appointment_sheet.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../docs/presentation/widgets/issue_document_sheet.dart';
import '../../orders/logic/orders_cubit.dart';
import '../../orders/presentation/orders_screen.dart';
import '../../patients/presentation/patients_screen.dart';
import '../../profile/logic/profile_cubit.dart';
import '../../queue/logic/queue_cubit.dart';
import '../../queue/presentation/queue_screen.dart';
import '../../queue/presentation/widgets/queue_walkin_sheet.dart';
import 'widgets/custom_nav_bar.dart';
import 'widgets/quick_action_sheet.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, this.currentPage = 0});

  final int currentPage;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  late int _currentIndex;

  static final _navItems = [
    NavBarItem(icon: AppSvgIcons.dashboardGrid, labelKey: LocaleKeys.nav_today),
    NavBarItem(icon: AppSvgIcons.family, labelKey: LocaleKeys.nav_queue),
    NavBarItem(icon: AppSvgIcons.flask, labelKey: LocaleKeys.nav_orders),
    NavBarItem(icon: AppSvgIcons.medicalFile, labelKey: LocaleKeys.nav_patients),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentPage;
    _syncDeviceOnLogin();
  }

  /// Fires the two device-housekeeping calls once, right when the
  /// authenticated user lands on the main app shell: registering the
  /// push-notification token and syncing the active UI language with the
  /// backend. Both are best-effort/fire-and-forget (see [ProfileCubit]) and
  /// skipped entirely for a guest session.
  void _syncDeviceOnLogin() {
    if (kIsGuest) return;
    final profileCubit = context.read<ProfileCubit>();

    // TODO(fcm): wire up `firebase_messaging` (add the package + platform
    // config) and pass the real device token here — left as a no-op until
    // then so this call doesn't fire with a bogus value.
    const fcmToken = '';
    if (fcmToken.isNotEmpty) profileCubit.registerFcmToken(fcmToken);

    profileCubit.syncAppLang(getIt<LocalStorage>().getLang());
  }

  void _goToQueue() => setState(() => _currentIndex = 1);

  void _openWalkin() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QueueWalkinSheet(
        onSubmit: (name, mrn) {
          getIt<QueueCubit>().addWalkIn(name: name, mrn: mrn);
          AppOverlay.showSuccess(LocaleKeys.queue_walkinSuccess.tr(namedArgs: {'name': name}));
          _goToQueue();
        },
      ),
    );
  }

  void _openQuickActions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuickActionSheet(
        onSelect: (action) {
          Navigator.pop(context);
          switch (action) {
            case QuickAction.walkin:
              _openWalkin();
            case QuickAction.book:
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
            case QuickAction.issueDoc:
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => IssueDocumentSheet(
                  onSubmit: (type, name, detail) => AppOverlay.showSuccess(
                    LocaleKeys.docsScreen_issueSuccess.tr(namedArgs: {'type': type, 'name': name}),
                  ),
                ),
              );
            case QuickAction.inbox:
              Navigator.pushNamed(context, Routes.inbox);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onGoToQueue: _goToQueue),
      const QueueScreen(),
      const OrdersScreen(),
      const PatientsScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: screens),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<QueueCubit, QueueState>(
              bloc: getIt<QueueCubit>(),
              builder: (context, queueState) {
                final waitingCount =
                    queueState is QueueSuccess ? queueState.snapshot.waiting.length : 0;
                return BlocBuilder<OrdersCubit, OrdersState>(
                  bloc: getIt<OrdersCubit>(),
                  builder: (context, ordersState) {
                    final ordersCount = ordersState is OrdersSuccess
                        ? ordersState.requests.where((r) => !r.hasResult).length
                        : 0;
                    return CustomNavBar(
                      currentIndex: _currentIndex,
                      items: _navItems,
                      badges: {1: waitingCount, 2: ordersCount},
                      onTap: (i) => setState(() => _currentIndex = i),
                      onFabTap: _openQuickActions,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
