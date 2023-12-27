import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myday/view/setting_notice_view.dart';

class ViewSetting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewSettingState();
}

class _ViewSettingState extends State<ViewSetting> {
  bool notice = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("설정"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                "알림 설정",
              ),
            ),
            Divider(
              height: 1.h,
            ),
            ListTile(
              title: const Text("알림 설정"),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSettingNotice()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
