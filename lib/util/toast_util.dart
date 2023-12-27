import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myday/model/day.dart';

class MyToast {
  MyToast._privateConstructor();

  static final MyToast _instance = MyToast._privateConstructor();

  factory MyToast() {
    return _instance;
  }

  final FToast _toast = FToast();

  init(BuildContext context) {
    _toast.init(context);
  }

  showToast(String msg) {
    Widget toast = Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0.r),
        color: Colors.black12,
      ),
      child: Text(msg),
    );

    _toast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
