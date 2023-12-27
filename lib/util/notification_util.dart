import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myday/data/enums.dart';
import 'package:myday/data/birthday.dart';
import 'package:myday/model/day.dart' as myday;
import 'package:myday/data/notice.dart';
import 'package:myday/db/db.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DayNotification {
  DayNotification._privateConstructor();

  static final DayNotification _instance = DayNotification._privateConstructor();

  factory DayNotification() {
    return _instance;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _init();
    Future.delayed(const Duration(seconds: 3), _requestNotificationPermission());
  }

  _init() async {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  _requestNotificationPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  NotificationDetails _getNotificationDetails() {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'myday',
      'myday_android',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: false,
    );

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(badgeNumber: 1),
    );
  }

  Future<void> showNotification() async {
    await flutterLocalNotificationsPlugin.show(0, 'test', 'test body', _getNotificationDetails());
  }

  _getTimeZones(int expiration) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    tz.TZDateTime date = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, expiration);
    tz.TZDateTime time = tz.TZDateTime(tz.local, date.year, date.month, date.day, 23, 55);

    return time;
  }

  Future<void> _scheduleNotification(Notice notice) async {
    String title = "";
    String body = "";

    tz.TZDateTime time = _getTimeZones(notice.date);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notice.id!, // Notification ID
      title,
      body,
      time, // Date and time to show the notification
      _getNotificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  zonedSchedule(myday.Day data) async {
    final List<Notice> notices = await DB().findNoticeWithId(data.id!);
    if (notices.isEmpty) {
      /// new
      if (data.getType == DayType.BIRTHDAY) {
        List<DateTime> list = Birthday().getList(firstDate: DateTime.fromMillisecondsSinceEpoch(data.date));
        for (var element in list) {
          await DB().addNoti(Notice(dId: data.id!, dayType: data.type, date: element.millisecondsSinceEpoch, use: 1));
        }

        final results = await DB().findNoticeWithId(data.id!);
        for (var element in results) {
          _scheduleNotification(element);
        }
      } else if (data.getType == DayType.ANNIVERSARY) {
        //
      } else {
        //
      }
    } else {
      if (data.getType == DayType.BIRTHDAY) {
        List<DateTime> list = Birthday().getList(lastDate: DateTime.fromMillisecondsSinceEpoch(notices.first.date));
        for (var element in list) {
          await DB().addNoti(Notice(dId: data.id!, dayType: data.type, date: element.millisecondsSinceEpoch, use: 1));
        }

        final results = await DB().findNoticeWithId(data.id!);
        for (var element in results) {
          _scheduleNotification(element);
        }
      } else if (data.getType == DayType.ANNIVERSARY) {
        //
      } else {
        //
      }
    }
  }

  cancelSchedule(List<int> ids) async {
    for (var element in ids) {
      _cancelSchedule(element);
    }
  }

  _cancelSchedule(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }
}
