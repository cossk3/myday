class Birthday {
  Birthday._privateConstructor();

  static final Birthday _instance = Birthday._privateConstructor();

  factory Birthday() {
    return _instance;
  }

  final DateTime _now = DateTime.now();

  getNextDate(DateTime date) {
    DateTime birthday = DateTime(_now.year, date.month, date.day);
    if (_now.isAfter(birthday)) {
      birthday = DateTime(_now.year + 1, date.month, date.day);
    }

    return birthday;
  }

  getScrollOffset(DateTime date) {
    int offset = _now.year - date.year;
    return offset > 0 ? offset - 1 : offset;
  }

  getList({DateTime? firstDate, DateTime? lastDate}) {
    if (firstDate != null) {
      int year = _now.year;
      DateTime birthday = DateTime(year, firstDate.month, firstDate.day);
      if (_now.isAfter(birthday)) {
        year++;
      }

      return List.generate(10, (index) => DateTime(year + index, firstDate.month, firstDate.day));
    } else if (lastDate != null) {
      int year = lastDate.year + 1;
      return List.generate(10, (index) => DateTime(year + index, lastDate.month, lastDate.day));
    }
  }
}
