import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:myday/data/enums.dart';
import 'package:myday/data/globals.dart';
import 'package:myday/model/day.dart';
import 'package:myday/db/db.dart';
import 'package:myday/provider/theme_mode_provider.dart';
import 'package:myday/view/add_view.dart';
import 'package:myday/view/detail_listview_view.dart';
import 'package:myday/widget/my_container.dart';
import 'package:provider/provider.dart';

class DetailView extends StatefulWidget {
  final Day data;
  final int diff;

  const DetailView({super.key, required this.data, required this.diff});

  @override
  State<StatefulWidget> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final PageController _pageController = PageController();
  late final DayType type;
  late final DateTime now, date;

  bool getOffset = false;
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    type = DayType.values[widget.data.type];

    now = DateTime.now();
    date = DateTime.fromMillisecondsSinceEpoch(widget.data.date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<DayMore>(
            onSelected: (DayMore item) {
              if (item == DayMore.EDIT) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddView(
                              edit: true,
                              data: widget.data,
                            )));
              }

              if (item == DayMore.DELETE) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                      title: const Text("삭제 확인"),
                      content: const Text(
                        "정말 삭제하시겠습니까?\n삭제하면 데이터를 복구할 수 없습니다.",
                      ),
                      actions: [
                        TextButton(
                          child: const Text("확인"),
                          onPressed: () {
                            // DB().removeDay(widget.data.id!);
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text("취소"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                ).whenComplete(() => Navigator.pop(context));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<DayMore>>[
              PopupMenuItem<DayMore>(
                value: DayMore.EDIT,
                child: Text(DayMore.EDIT.text),
              ),
              PopupMenuItem<DayMore>(
                value: DayMore.DELETE,
                child: Text(DayMore.DELETE.text),
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            SizedBox.expand(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 50.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3.w,
                    color: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black54,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.w,
                      color: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black54,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.data.title,
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      type == DayType.MONTH_PERIOD
                          ? Text(DateFormat("${widget.data.period! == 1 ? '매월' : '${widget.data.period!}개월'} ${date.day}일 마다")
                              .format(DateTime.fromMillisecondsSinceEpoch(widget.data.date)))
                          : type == DayType.WEEK_PERIOD
                              ? Text(DateFormat(
                                      "${widget.data.period! == 1 ? '매주' : '${widget.data.period!}주'} ${date.getWeekString()}요일 마다")
                                  .format(DateTime.fromMillisecondsSinceEpoch(widget.data.date)))
                              : Text(DateFormat("yyyy.MM.dd").format(DateTime.fromMillisecondsSinceEpoch(widget.data.date))),
                      40.verticalSpace,
                      Text(
                        type == DayType.ANNIVERSARY ? "D+${widget.diff}" : "D-${widget.diff}",
                        style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox.expand(
              child: DetailListViewView(
                data: widget.data,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
