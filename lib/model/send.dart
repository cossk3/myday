class Send {
  String? to;
  NotificationData? notification;
  String? priority;
  bool? contentAvailable;

  Send({this.to, this.notification, this.priority, this.contentAvailable});

  Send.fromJson(dynamic json) {
    to = json['to'];
    notification = json['notification'] != null ? NotificationData.fromJson(json['notification']) : null;
    priority = json['priority'];
    contentAvailable = json['content_available'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['to'] = to;
    if (notification != null) {
      map['notification'] = notification!.toJson();
    }
    if (priority != null) {
      map['priority'] = priority!;
    }
    map['content_available'] = contentAvailable!;
    return map;
  }
}

class NotificationData {
  String? title;
  String? body;

  NotificationData({
    this.title,
    this.body,
  });

  NotificationData.fromJson(dynamic json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    return map;
  }
}
