import 'package:equatable/equatable.dart';

/// The booking-policy toggles on "سياسة الحجز".
class PolicySettingsModel extends Equatable {
  const PolicySettingsModel({
    this.allowCancellation = true,
    this.allowReschedule = true,
    this.autoRefund = false,
    this.reminderDayBefore = true,
    this.reminderHourBefore = true,
    this.checkinRequest = true,
    this.videoPrepayment = true,
  });

  final bool allowCancellation;
  final bool allowReschedule;
  final bool autoRefund;
  final bool reminderDayBefore;
  final bool reminderHourBefore;
  final bool checkinRequest;
  final bool videoPrepayment;

  PolicySettingsModel copyWith({
    bool? allowCancellation,
    bool? allowReschedule,
    bool? autoRefund,
    bool? reminderDayBefore,
    bool? reminderHourBefore,
    bool? checkinRequest,
    bool? videoPrepayment,
  }) =>
      PolicySettingsModel(
        allowCancellation: allowCancellation ?? this.allowCancellation,
        allowReschedule: allowReschedule ?? this.allowReschedule,
        autoRefund: autoRefund ?? this.autoRefund,
        reminderDayBefore: reminderDayBefore ?? this.reminderDayBefore,
        reminderHourBefore: reminderHourBefore ?? this.reminderHourBefore,
        checkinRequest: checkinRequest ?? this.checkinRequest,
        videoPrepayment: videoPrepayment ?? this.videoPrepayment,
      );

  @override
  List<Object?> get props => [
        allowCancellation,
        allowReschedule,
        autoRefund,
        reminderDayBefore,
        reminderHourBefore,
        checkinRequest,
        videoPrepayment,
      ];
}
