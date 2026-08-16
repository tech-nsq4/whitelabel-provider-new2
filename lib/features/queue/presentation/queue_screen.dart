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
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/queue_patient_model.dart';
import '../data/models/queue_snapshot_model.dart';
import '../logic/queue_cubit.dart';
import 'widgets/queue_done_tile.dart';
import 'widgets/queue_empty_state.dart';
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
      AppOverlay.showSuccess(
          LocaleKeys.queue_calledInToast.tr(namedArgs: {'name': patient.name}));
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
            AppOverlay.showSuccess(LocaleKeys.queue_cancelSuccess
                .tr(namedArgs: {'name': patient.name}));
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
              isLoading: state is QueueLoading || state is QueueInitial,
              error: state is QueueError
                  ? ErrorModel(
                      code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              onRetry: () => getIt<QueueCubit>().loadQueue(),
              builder: (context) => ListView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 108.h),
                children: [
                  AppScreenHeader(
                    eyebrow: LocaleKeys.queue_eyebrow.tr(),
                    title: LocaleKeys.queue_title.tr(),
                    trailing: AppHeaderIconButton(
                      svgIcon: AppSvgIcons.plus,
                      color: AppColors.primaryColor.themeColor,
                      onTap: _openWalkin,
                    ),
                  ),
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
                    onCallIn: () => _callIn(p),
                    onCancel: () => _confirmCancel(p),
                  ),
              ];
      case 1:
        return snapshot.inRoom.isEmpty
            ? [QueueEmptyState(text: LocaleKeys.queue_emptyRoom.tr())]
            : [
                for (final p in snapshot.inRoom)
                  QueueRoomCard(patient: p, onTap: () => _startConsult(p)),
              ];
      default:
        return snapshot.done.isEmpty
            ? [QueueEmptyState(text: LocaleKeys.queue_emptyDone.tr())]
            : [for (final p in snapshot.done) QueueDoneTile(patient: p)];
    }
  }
}
