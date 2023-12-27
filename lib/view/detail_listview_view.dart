import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myday/data/enums.dart';
import 'package:myday/data/globals.dart';
import 'package:myday/model/day.dart';
import 'package:myday/provider/theme_mode_provider.dart';
import 'package:provider/provider.dart';

class DetailListViewView extends StatefulWidget {
  final Day data;

  const DetailListViewView({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _DetailListViewViewState();
}

class _DetailListViewViewState extends State<DetailListViewView> {
  final ScrollController _scrollController = ScrollController();

  late final Day data;
  late final DateTime now, date;

  bool today = false;
  List<ListTile> list = List.empty(growable: true);

  //birthday
  int birthYear = 1;

  //anniversary
  int anniDay = 1;
  int anniNextDay = 1;
  int anniYear = 1;

  //month period
  late int monthPeriodYear, monthPeriodMonth;

  @override
  void initState() {
    // TODO: implement initState
    data = widget.data;

    now = DateTime.now();
    date = data.getDate;

    if (data.getType == DayType.MONTH_PERIOD) {
      monthPeriodYear = date.year;
      monthPeriodMonth = date.month;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      _setScroll();
    });

    super.initState();
  }

  _setScroll() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(extent * data.offset, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: extent,
      controller: _scrollController,
      itemBuilder: (BuildContext context, int idx) {
        if (data.getType == DayType.ANNIVERSARY) {
          return _getAnniversaryTile(idx);
        } else if (data.getType == DayType.BIRTHDAY) {
          return _getBirthdayTile(idx);
        } else if (data.getType == DayType.MONTH_PERIOD) {
          return _getMonthPeriodTile(idx);
        } else if (data.getType == DayType.WEEK_PERIOD) {
          return _getWeekPeriodTile(idx);
        } else if (data.getType == DayType.DAY_PERIOD) {
          return _getDayPeriodTile(idx);
        }
      },
    );
  }

  _getBirthdayTile(int idx) {
    DateTime displayDate = DateTime(date.year + birthYear, date.month, date.day);

    if (list.length > idx) {
      return list[idx];
    }

    ListTile tile;
    if (displayDate.isSame(now) && !today) {
      today = true;

      tile = ListTile(
        title: Text("오늘 ${idx + 1}번째 생일"),
        subtitle: Text(DateFormat(mydayDateFormat).format(displayDate)),
        selected: true,
        selectedColor: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black,
        selectedTileColor: context.watch<ThemeModeProvider>().isDark ? Colors.white12 : Colors.black12,
      );
    } else {
      bool next = widget.data.nextDate.isSame(displayDate);

      tile = ListTile(
        title: Text("${idx + 1}번째 생일"),
        subtitle: Text(DateFormat(mydayDateFormat).format(displayDate)),
        selected: next,
        selectedColor: next ? (context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black) : null,
        selectedTileColor: next ? (context.watch<ThemeModeProvider>().isDark ? Colors.white12 : Colors.black12) : null,
      );
      birthYear++;
    }

    list.add(tile);
    return tile;
  }

  _getAnniversaryTile(int idx) {
    DateTime displayDate = date.add(Duration(days: anniNextDay - 1));
    DateTime yearDate = DateTime(date.year + anniYear, date.month, date.day);
    int diff = now.difference(date).inDays + 1;

    if (list.length > idx) {
      return list[idx];
    }

    if (yearDate.isSame(now) || displayDate.isSame(now)) today = true;

    ListTile tile;
    if (anniDay * anniNextDay > diff && !today) {
      today = true;

      tile = ListTile(
        title: Text("오늘 $diff일"),
        subtitle: Text(DateFormat(mydayDateFormat).format(now)),
        selected: true,
        selectedColor: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black,
        selectedTileColor: context.watch<ThemeModeProvider>().isDark ? Colors.white12 : Colors.black12,
      );
    } else if (yearDate.isBefore(displayDate)) {
      bool same = yearDate.isSame(now);

      tile = ListTile(
        title: Text("${same ? "오늘 " : ""}$anniYear주년"),
        subtitle: Text(DateFormat(mydayDateFormat).format(yearDate)),
        selected: same,
        selectedColor: same ? (context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black) : null,
        selectedTileColor: same ? (context.watch<ThemeModeProvider>().isDark ? Colors.white12 : Colors.black12) : null,
      );
      anniYear++;
    } else {
      bool same = displayDate.isSame(now);

      tile = ListTile(
        title: Text("${same ? "오늘 " : ""}$anniNextDay일"),
        subtitle: Text(DateFormat(mydayDateFormat).format(displayDate)),
        selected: same,
        selectedColor: same ? (context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black) : null,
        selectedTileColor: same ? (context.watch<ThemeModeProvider>().isDark ? Colors.white12 : Colors.black12) : null,
      );

      if (anniNextDay == 1) {
        anniNextDay = 50;
      } else if (anniNextDay == 50) {
        anniNextDay = 100;
      } else {
        anniNextDay += 100;
      }
    }

    list.add(tile);
    return tile;
  }

  _getMonthPeriodTile(int idx) {
    int period = data.period!;
    DateTime displayDate = DateTime(monthPeriodYear, monthPeriodMonth, date.day);

    if (list.length > idx) {
      return list[idx];
    }

    ListTile tile;
    if (now.isBefore(displayDate) && !today) {
      today = true;

      tile = ListTile(
        title: Text("$idx번째 ${data.title}"),
        subtitle: Text(DateFormat(mydayDateFormat).format(displayDate)),
        selected: true,
        selectedColor: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black,
        selectedTileColor: context.watch<ThemeModeProvider>().isDark ? Colors.white12 : Colors.black12,
      );
    } else {
      tile = ListTile(
        title: Text("$idx번째 ${data.title}"),
        subtitle: Text(DateFormat(mydayDateFormat).format(displayDate)),
      );
    }

    monthPeriodMonth += period;
    if (monthPeriodMonth > 12) {
      monthPeriodMonth -= 12;
      monthPeriodYear += 1;
    }

    list.add(tile);
    return tile;
  }

  _getWeekPeriodTile(int idx) {
    int period = data.period!;
    int day = 7 * period;

    DateTime displayDate = date.add(Duration(days: day * idx));
    if (list.length > idx) {
      return list[idx];
    }

    ListTile tile;
    if (now.isBefore(displayDate) && !today) {
      today = true;

      tile = ListTile(
        title: Text("$idx번째 ${data.title}"),
        subtitle: Text(DateFormat(mydayDateFormat).format(displayDate)),
        selected: true,
        selectedColor: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black,
        selectedTileColor: context.watch<ThemeModeProvider>().isDark ? Colors.white12 : Colors.black12,
      );
    } else {
      tile = ListTile(
        title: Text("$idx번째 ${data.title}"),
        subtitle: Text(DateFormat(mydayDateFormat).format(displayDate)),
      );
    }

    list.add(tile);
    return tile;
  }

  _getDayPeriodTile(int idx) {
    int period = data.period!;

    DateTime displayDate = date.add(Duration(days: period * idx));
    if (list.length > idx) {
      return list[idx];
    }

    ListTile tile;
    if (now.isSame(displayDate) && !today) {
      today = true;

      tile = ListTile(
        title: Text("$idx번째 ${data.title}"),
        subtitle: Text(DateFormat(mydayDateFormat).format(displayDate)),
        selected: true,
        selectedColor: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black,
        selectedTileColor: context.watch<ThemeModeProvider>().isDark ? Colors.white12 : Colors.black12,
      );
    } else {
      tile = ListTile(
        title: Text("$idx번째 ${data.title}"),
        subtitle: Text(DateFormat(mydayDateFormat).format(displayDate)),
      );
    }

    list.add(tile);
    return tile;
  }
}
