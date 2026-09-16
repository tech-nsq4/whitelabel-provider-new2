import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_segmented_tabs.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/custom_tap_effect.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/queue_filter.dart';
import '../data/models/queue_patient_model.dart';
import '../data/models/queue_snapshot_model.dart';
import '../logic/queue_cubit.dart';
import 'widgets/queue_done_tile.dart';
import 'widgets/queue_empty_state.dart';
import 'widgets/queue_filter_sheet.dart';
import 'widgets/queue_room_card.dart';
import 'widgets/queue_waiting_card.dart';
import 'widgets/queue_walkin_sheet.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    final cubit = getIt<QueueCubit>();
    if (cubit.state is QueueInitial) cubit.loadQueue();
  }

  Future<void> _openFilterSheet() async {
    final result = await showModalBottomSheet<QueueFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QueueFilterSheet(current: getIt<QueueCubit>().filter),
    );
    if (result != null) getIt<QueueCubit>().applyFilter(result);
  }

  void _openWalkin() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QueueWalkinSheet(
        onSubmit: (name, mrn) {
          getIt<QueueCubit>().addWalkIn(name: name, mrn: mrn);
          AppOverlay.showSuccess(
              LocaleKeys.queue_walkinSuccess.tr(namedArgs: {'name': name}));
        },
      ),
    );
  }

  Future<void> _callIn(QueuePatientModel patient) async {
    final ok = await getIt<QueueCubit>().callIn(patient);
    if (ok) {
      // AppOverlay.showSuccess(
      //     LocaleKeys.queue_calledInToast.tr(namedArgs: {'name': patient.name}));
    }
  }

  void _confirmCancel(QueuePatientModel patient) {
    showDialog(
      context: context,
      builder: (_) => AppConfirmDialog(
        icon: Icons.event_busy_rounded,
        iconColor: AppColors.errorColor.themeColor,
        title: LocaleKeys.queue_cancelConfirmTitle.tr(),
        message: LocaleKeys.queue_cancelConfirmMessage
            .tr(namedArgs: {'name': patient.name}),
        confirmLabel: LocaleKeys.queue_cancelAction.tr(),
        cancelLabel: LocaleKeys.common_cancel.tr(),
        confirmColor: AppColors.errorColor.themeColor,
        onConfirm: () async {
          Navigator.pop(context);
          final ok = await getIt<QueueCubit>().cancel(patient);
          if (ok) {
            // AppOverlay.showSuccess(LocaleKeys.queue_cancelSuccess
            //     .tr(namedArgs: {'name': patient.name}));
          }
        },
      ),
    );
  }

  Future<void> _startConsult(QueuePatientModel patient) async {
    if (patient.status != 'in_progress') {
      final ok = await getIt<QueueCubit>().startConsultation(patient);
      if (!ok || !mounted) return;
    }
    Navigator.pushNamed(context, Routes.consultation,
        arguments: {'patient': patient});
  }

  void _openDetails(QueuePatientModel patient, int tabIndex) {
    Navigator.pushNamed(context, Routes.queueDetails, arguments: {
      'patient': patient,
      'tabIndex': tabIndex,
      'onCallIn': tabIndex == 0 ? () => _callIn(patient) : null,
      'onCancel': tabIndex == 0 ? () => _confirmCancel(patient) : null,
      'onConsultAction': tabIndex == 1 ? () => _startConsult(patient) : null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<QueueCubit, QueueState>(
          bloc: getIt<QueueCubit>(),
          builder: (context, state) {
            return CustomScreenStateLayout(
              onRefresh: ()async{
                getIt<QueueCubit>().loadQueue();
              },
              isLoading: state is QueueLoading || state is QueueInitial,
              error: state is QueueError
                  ? ErrorModel(
                      code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              onRetry: () => getIt<QueueCubit>().loadQueue(),
              builder: (context) => ListView(
                // physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 108.h),
                children: [
                  AppScreenHeader(
                    eyebrow: LocaleKeys.queue_eyebrow.tr(),
                    title: LocaleKeys.queue_title.tr(),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppHeaderIconButton(
                          svgIcon: AppSvgIcons.filter,
                          color: getIt<QueueCubit>().filter.isActive
                              ? AppColors.primaryColor.themeColor
                              : null,
                          badgeCount: getIt<QueueCubit>().filter.activeCount,
                          onTap: _openFilterSheet,
                        ),
                        8.width,
                        AppHeaderIconButton(
                          svgIcon: AppSvgIcons.plus,
                          color: AppColors.primaryColor.themeColor,
                          onTap: _openWalkin,
                        ),
                      ],
                    ),
                  ),
                  if (getIt<QueueCubit>().filter.isActive) _activeFilterSummary(),
                  18.height,
                  _buildTabs((state as QueueSuccess).snapshot),
                  18.height,
                  ..._buildTabContent(state.snapshot),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _activeFilterSummary() {
    final filter = getIt<QueueCubit>().filter;
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              filter.clinicName ?? '',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryColor.themeColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          8.width,
          CustomTapEffect(
            onTap: () => getIt<QueueCubit>().clearFilter(),
            child: AppText(
              LocaleKeys.queue_filterClear.tr(),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.errorColor.themeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(QueueSnapshotModel snapshot) {
    return AppSegmentedTabs(
      labels: [
        LocaleKeys.queue_tabWaiting.tr(),
        LocaleKeys.queue_tabInRoom.tr(),
        LocaleKeys.queue_tabDone.tr(),
      ],
      counts: [
        snapshot.waiting.length,
        snapshot.inRoom.length,
        snapshot.done.length
      ],
      selectedIndex: _tabIndex,
      onChanged: (i) {
        setState(() => _tabIndex = i);
        getIt<QueueCubit>().refreshTab(i);
      },
    );
  }

  List<Widget> _buildTabContent(QueueSnapshotModel snapshot) {
    switch (_tabIndex) {
      case 0:
        return snapshot.waiting.isEmpty
            ? [QueueEmptyState(text: LocaleKeys.queue_emptyWaiting.tr())]
            : [
                for (final p in snapshot.waiting)
                  QueueWaitingCard(
                    patient: p,
                    onTap: () => _openDetails(p, 0),
                    onCallIn: () => _callIn(p),
                    onCancel: () => _confirmCancel(p),
                  ),
              ];
      case 1:
        return snapshot.inRoom.isEmpty
            ? [QueueEmptyState(text: LocaleKeys.queue_emptyRoom.tr())]
            : [
                for (final p in snapshot.inRoom)
                  QueueRoomCard(
                    patient: p,
                    onTap: () => _openDetails(p, 1),
                    onConsultAction: () => _startConsult(p),
                  ),
              ];
      default:
        return snapshot.done.isEmpty
            ? [QueueEmptyState(text: LocaleKeys.queue_emptyDone.tr())]
            : [
                for (final p in snapshot.done)
                  QueueDoneTile(patient: p, onTap: () => _openDetails(p, 2)),
              ];
    }
  }
}
