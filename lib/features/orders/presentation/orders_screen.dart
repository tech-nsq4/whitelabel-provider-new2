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
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_segmented_tabs.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/lab_order_model.dart';
import '../logic/orders_cubit.dart';
import 'widgets/order_card.dart';
import 'widgets/order_upload_sheet.dart';

/// Bottom nav's "Orders" destination — lab/imaging requests raised from
/// consultations.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    final cubit = getIt<OrdersCubit>();
    if (cubit.state is OrdersInitial) cubit.loadOrders();
  }

  void _onAction(LabOrderModel order) {
    if (order.status == LabOrderStatus.newOrder) {
      getIt<OrdersCubit>().startOrder(order.id);
      AppOverlay.showSuccess(LocaleKeys.orders_startSuccess
          .tr(namedArgs: {'test': order.testName, 'name': order.patientName}));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrderUploadSheet(
        order: order,
        onSubmit: (reading, flag) {
          getIt<OrdersCubit>().markUploaded(order.id);
          AppOverlay.showSuccess(LocaleKeys.orders_uploadSuccess
              .tr(namedArgs: {'test': order.testName, 'name': order.patientName}));
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
        child: BlocBuilder<OrdersCubit, OrdersState>(
          bloc: getIt<OrdersCubit>(),
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is OrdersLoading || state is OrdersInitial,
              error: state is OrdersError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              onRetry: () => getIt<OrdersCubit>().loadOrders(),
              builder: (context) {
                final orders = (state as OrdersSuccess).orders;
                final filtered = switch (_tabIndex) {
                  1 => orders.where((o) => o.status == LabOrderStatus.newOrder).toList(),
                  2 => orders.where((o) => o.status == LabOrderStatus.inProgress).toList(),
                  _ => orders,
                };

                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 108.h),
                  children: [
                    AppScreenHeader(
                      eyebrow: LocaleKeys.ordersScreen_subtitle.tr(),
                      title: LocaleKeys.ordersScreen_title.tr(),
                    ),
                    16.height,
                    AppCard(
                      color: AppColors.surfaceColor.themeColor,
                      borderColor: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSvgIcon(AppSvgIcons.clock,
                              size: 17.sp, color: AppColors.primaryColor.themeColor),
                          11.width,
                          Expanded(
                            child: AppText(
                              LocaleKeys.orders_infoBanner.tr(),
                              fontSize: 11,
                              height: 1.7,
                              color: AppColors.textSecondaryColor.themeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    AppSegmentedTabs(
                      labels: [
                        LocaleKeys.orders_tabAll.tr(),
                        LocaleKeys.orders_tabNew.tr(),
                        LocaleKeys.orders_tabInProgress.tr(),
                      ],
                      selectedIndex: _tabIndex,
                      onChanged: (i) => setState(() => _tabIndex = i),
                    ),
                    16.height,
                    for (final order in filtered)
                      OrderCard(order: order, onAction: () => _onAction(order)),
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
