import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyContainer extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final Widget? child;

  const MyContainer({
    super.key,
    this.alignment,
    this.padding,
    this.color,
    this.margin,
    this.decoration,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: padding ?? EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      margin: margin,
      color: color,
      decoration: decoration,
      width: width,
      height: height,
      child: child,
    );
  }
}
