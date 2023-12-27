import 'package:myday/data/birthday.dart';
import 'package:myday/data/enums.dart';
import 'package:myday/data/anniversary.dart';
import 'package:myday/data/birthday.dart';
import 'package:myday/data/period.dart';

class Day {
  int? id;
  final String title;
  final int type;
  final int date;
  final int? period;
  int widget;

  late DateTime nextDate;
  late int offset;

  Day({
    this.id,
    required this.title,
    required this.type,
    required this.date,
    this.period,
    this.widget = 0,
  }) {
    switch (getType) {
      case DayType.BIRTHDAY:
        nextDate = Birthday().getNextDate(getDate);
        offset = Birthday().getScrollOffset(getDate);
        break;
      case DayType.ANNIVERSARY:
        nextDate = Anniversary().getNextDate(getDate);
        offset = Anniversary().getScrollOffset(getDate);
        break;
      case DayType.MONTH_PERIOD:
        nextDate = Period().getMonthNextDate(period!, getDate);
        offset = Period().getMonthScrollOffset(period!, getDate);
        break;
      case DayType.WEEK_PERIOD:
        nextDate = Period().getWeekNextDate(period!, getDate);
        offset = Period().getWeekScrollOffset(period!, getDate);
        break;
      case DayType.DAY_PERIOD:
        nextDate = Period().getDayNextDate(period!, getDate);
        offset = Period().getDayScrollOffset(period!, getDate);
        break;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'date': date,
      'period': period,
      'widget': widget,
    };
  }

  DateTime get getDate => DateTime.fromMillisecondsSinceEpoch(date);

  DayType get getType => DayType.values[type];

  int? get diff => getType == DayType.BIRTHDAY
      ? nextDate.difference(DateTime.now()).inDays
      : getType == DayType.ANNIVERSARY
          ? DateTime.now().difference(getDate).inDays + 1
          : (nextDate.difference(DateTime.now()).inDays + 1);
}
