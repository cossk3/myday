import 'package:flutter/foundation.dart';
import 'package:myday/data/enums.dart';
import 'package:myday/model/day.dart';

class AddProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isEdit = false;

  String _title = "";
  DayType? _type;
  DateTime? _date;
  int? _period;

  Day? _day;

  bool get isEdit => _isEdit;

  String get title => _title;

  DayType? get type => _type;

  DateTime? get date => _date;

  int? get period => _period;

  bool get isSave =>
      (_title.isNotEmpty && _type != null && !_type!.isPeriod && _date != null) ||
      (_title.isNotEmpty && _type != null && _type!.isPeriod && _date != null && _period != null);

  bool get isDifference =>
      _isEdit ? _day!.title != _title || _day!.getType != _type || _day!.getDate != _date || _day!.period != _period : false;

  Day get getDay => Day(
        id: _day?.id,
        title: _title,
        type: _type!.index,
        date: _date!.millisecondsSinceEpoch,
        period: _period,
        widget: _day?.widget ?? 0,
      );

  setEditDay(Day day) {
    _day = day;

    _isEdit = true;
    _title = day.title;
    _type = day.getType;
    _date = day.getDate;
    _period = day.period;
  }

  setTitle(String t) {
    _title = t;
    notifyListeners();
  }

  setType(DayType? t) {
    _type = t;
    notifyListeners();
  }

  initDate(DateTime? d) {
    _date = d;
  }

  setDate(DateTime? d) {
    _date = d;
    notifyListeners();
  }

  setPeriod(int? p) {
    _period = p;
    notifyListeners();
  }

  clear() {
    _title = "";
    _type = null;
    _date = null;
    _period = null;

    _day = null;
    _isEdit = false;
  }
}
