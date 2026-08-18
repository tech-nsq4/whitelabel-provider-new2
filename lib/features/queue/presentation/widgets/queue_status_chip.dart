import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_status_chip.dart';

/// Translates a raw appointment status
/// (`pending`/`confirmed`/`in_progress`/`completed`/`cancelled`) into its
/// localized [AppStatusChip] — shared between the room card and the
/// details screen. Renders nothing for an unrecognized/missing status.
class QueueStatusChip extends StatelessWidget {
  const QueueStatusChip({super.key, required this.status});

  final String? status;

  static String? _label(String? status) => switch (status) {
        'pending' => LocaleKeys.status_pending.tr(),
        'confirmed' => LocaleKeys.status_confirmed.tr(),
        'in_progress' => LocaleKeys.status_inProgress.tr(),
        'completed' => LocaleKeys.status_completed.tr(),
        'cancelled' => LocaleKeys.status_cancelled.tr(),
        _ => null,
      };

  static AppStatusTone _tone(String? status) => switch (status) {
        'in_progress' => AppStatusTone.warning,
        'completed' => AppStatusTone.positive,
        'cancelled' => AppStatusTone.critical,
        _ => AppStatusTone.muted,
      };

  @override
  Widget build(BuildContext context) {
    final label = _label(status);
    if (label == null) return const SizedBox.shrink();
    return AppStatusChip(label, tone: _tone(status));
  }
}
