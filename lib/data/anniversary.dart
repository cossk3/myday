class Anniversary {
  Anniversary._privateConstructor();

  static final Anniversary _instance = Anniversary._privateConstructor();

  factory Anniversary() {
    return _instance;
  }

  final DateTime _now = DateTime.now();

  int _addDay = 1;
  int _idx = 0;

  _calc(DateTime date) {
    _addDay = 1;
    _idx = 0;
    int day = _now.difference(date).inDays + 1;

    do {
      if (_addDay == 1) {
        _addDay = 50;
      } else if (_addDay == 50) {
        _addDay = 100;
      } else {
        _addDay += 100;
      }

      _idx++;
    } while (day > _addDay);
  }

  getNextDate(DateTime date) {
    _calc(date);
    return date.add(Duration(days: _addDay - 1));
  }

  getScrollOffset(DateTime date) {
    _calc(date);
    int alpa = (_addDay / 365).round();
    alpa > 0 ? alpa-- : alpa;
    return _idx + alpa;
  }
}
