import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myday/model/send.dart';
import 'package:http/http.dart' as http;
import 'package:myday/data/globals.dart';
import 'package:myday/util/preferences_util.dart';

class Messaging {
  Messaging._privateConstructor();
  static final Messaging _instance = Messaging._privateConstructor();

  factory Messaging() {
    return _instance;
  }

  getMyDeviceToken() async {
    token = await FirebaseMessaging.instance.getToken() ?? "";
    print("내 디바이스 토큰: $token");

    Preferences().setToken();
  }

  listeningMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            ),
          ),
        );

        print("Foreground 메시지 수신: ${message.notification!.body!}");
      }
    });
  }


  /*await Messaging().getMyDeviceToken();
    Messaging().sendData(
      SendData(
        notification: NotificationData(
          body: "test body",
          title: "test title",
        ),
        contentAvailable: true,
        to: token,
      ),
    );*/
  sendData(Send data) async {
    String json =
        "\{\"to\":\"${data.to}\",\"content_available\":${data.contentAvailable},\"notification\" : {\"title\" : \"${data.notification!.title!}\",\"body\" : \"${data.notification!.body!}\"\}\}";

    print("TTT: $json");
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    await http.post(url, body: json, headers: {
      "Authorization":
          "key=AAAASC2pj7c:APA91bHPIkLucfOoRgo0KI5pCXcY4uU4mkWshbJlQF3i8j0Y5ogkP-ny3JQah0S2skLVq-V6D88S4DQBAEcCTwG3GyHo08jKxotUB8zZhf9TJ24X5GGJrVI28_61Nr9gFnVmSOIcuFQf",
      "Content-Type": "application/json"
    });
  }
}
