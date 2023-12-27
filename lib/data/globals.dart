import 'package:myday/model/day.dart';

const String mydayDateFormat = "yyyy.MM.dd (E)";

const String storageReceiveNotice = 'receive_notice';
const String storageNoticeSettingUse = '_use';
const String storageNoticeSettingHour = '_hour';
const String storageNoticeSettingMin = '_min';

const double extent = 60;
String token = "";

bool receiveNotice = true;

extension DateTimeExtension on DateTime {
  getWeekString() {
    switch (weekday) {
      case 1:
        return "월";
      case 2:
        return "화";
      case 3:
        return "수";
      case 4:
        return "목";
      case 5:
        return "금";
      case 6:
        return "토";
      case 7:
        return "일";
    }
  }

  isSame(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}