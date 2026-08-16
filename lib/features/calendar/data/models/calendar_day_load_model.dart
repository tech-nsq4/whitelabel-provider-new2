import 'package:equatable/equatable.dart';

enum CalendarLoadLevel { light, medium, busy }

/// One day cell's booking density on the month grid.
class CalendarDayLoadModel extends Equatable {
  const CalendarDayLoadModel({required this.day, required this.count, required this.level});

  final int day;
  final int count;
  final CalendarLoadLevel level;

  @override
  List<Object?> get props => [day, count, level];
}
