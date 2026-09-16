import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/locale_keys.dart';

class ScheduleLabels {
  ScheduleLabels._();

  static const List<String> weekOrder = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  static String day(String raw) {
    switch (raw) {
      case 'Saturday':
        return LocaleKeys.schedules_daySaturday.tr();
      case 'Sunday':
        return LocaleKeys.schedules_daySunday.tr();
      case 'Monday':
        return LocaleKeys.schedules_dayMonday.tr();
      case 'Tuesday':
        return LocaleKeys.schedules_dayTuesday.tr();
      case 'Wednesday':
        return LocaleKeys.schedules_dayWednesday.tr();
      case 'Thursday':
        return LocaleKeys.schedules_dayThursday.tr();
      case 'Friday':
        return LocaleKeys.schedules_dayFriday.tr();
      default:
        return raw;
    }
  }

  static String type(String? raw) {
    switch (raw) {
      case 'clinic':
        return LocaleKeys.schedules_modeClinic.tr();
      case 'online':
        return LocaleKeys.schedules_modeOnline.tr();
      case 'home':
        return LocaleKeys.schedules_modeHome.tr();
      default:
        return raw ?? '';
    }
  }
}
