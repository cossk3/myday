import 'package:myday/data/globals.dart';

class Period {
  Period._privateConstructor();

  static final Period _instance = Period._privateConstructor();

  factory Period() {
    return _instance;
  }

  final DateTime _now = DateTime.now();

  int _mIdx = 0;
  late DateTime _mPeriodDate;

  int _wIdx = 0;
  late DateTime _wPeriodDate;

  int _dIdx = 0;
  late DateTime _dPeriodDate;

  ///month period
  _calcM(int period, DateTime date) {
    int y = date.year;
    int month = date.month;
    _mIdx = 0;

    do {
      _mIdx++;
      month += period;

      if (month > 12) {
        month -= 12;
        y += 1;
      }

      _mPeriodDate = DateTime(y, month, date.day);
    } while (_now.isAfter(_mPeriodDate));
  }

  getMonthNextDate(int period, DateTime date) {
    _calcM(period, date);
    return _mPeriodDate;
  }

  getMonthScrollOffset(int period, DateTime date) {
    _calcM(period, date);
    return _mIdx;
  }

  ///week period
  _calcW(int period, DateTime date) {
    int day = 7 * period;
    _wIdx = 0;

    _wPeriodDate = date;
    if (_now == _wPeriodDate) {
      return;
    }

    while (_now.isAfter(_wPeriodDate)) {
      _wIdx++;
      _wPeriodDate = _wPeriodDate.add(Duration(days: day));
    }
  }

  getWeekNextDate(int period, DateTime date) {
    _calcW(period, date);
    return _wPeriodDate;
  }

  getWeekScrollOffset(int period, DateTime date) {
    _calcW(period, date);
    return _wIdx;
  }

  ///day period
  _calcD(int period, DateTime date) {
    _dIdx = 0;
    _dPeriodDate = date;

    if (_now.isSame(_dPeriodDate)) {
      return;
    }

    while (_now.isAfter(_dPeriodDate)) {
      _dIdx++;
      _dPeriodDate = _dPeriodDate.add(Duration(days: period * _dIdx));
    }
  }

  getDayNextDate(int period, DateTime date) {
    _calcD(period, date);
    return _dPeriodDate;
  }

  getDayScrollOffset(int period, DateTime date) {
    _calcD(period, date);
    return _dIdx;
  }
}
