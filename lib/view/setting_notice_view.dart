import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myday/data/enums.dart';
import 'package:myday/data/globals.dart';
import 'package:myday/model/day.dart';

class ViewSettingNotice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewSettingNoticeState();
}

class _ViewSettingNoticeState extends State<ViewSettingNotice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("알림 설정"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text('알림 받기'),
              trailing: Switch(
                value: receiveNotice,
                onChanged: (bool value) {
                  setState(() {
                    receiveNotice = value;
                    // GetStorage().write(storageReceiveNotice, receiveNotice);
                  });
                },
              ),
            ),
            /*Expanded(
                child: ListView.separated(
              itemCount: noticeSettingList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  enabled: receiveNotice ? true : false,
                  title: Text(noticeSettingList[index].type.text),
                  subtitle: Text(
                    '${noticeSettingList[index].hour < 12 ? "오전" : "오후"} ${noticeSettingList[index].hour}시 ${noticeSettingList[index].min < 10 ? '0' : ''}${noticeSettingList[index].min}분 >',
                  ),
                  trailing: Switch(
                    value: noticeSettingList[index].use,
                    onChanged: (bool value) {
                      setState(() {
                        noticeSettingList[index].use = value;
                        GetStorage().write('${noticeSettingList[index].type.name}$storageNoticeSettingUse', value);
                      });
                    },
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 300,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
                                noticeSettingList[index].hour, noticeSettingList[index].min),
                            onDateTimeChanged: (DateTime value) {
                              setState(() {
                                noticeSettingList[index].hour = value.hour;
                                noticeSettingList[index].min = value.minute;
                                GetStorage().write('${noticeSettingList[index].type.name}$storageNoticeSettingHour', value.hour);
                                GetStorage().write('${noticeSettingList[index].type.name}$storageNoticeSettingMin', value.minute);
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ))*/
          ],
        ),
      ),
    );
  }
}
