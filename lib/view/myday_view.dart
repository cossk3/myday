import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:myday/bloc/day_bloc.dart';
import 'package:myday/bloc/day_event.dart';
import 'package:myday/bloc/day_state.dart';
import 'package:myday/data/enums.dart';
import 'package:myday/model/day.dart';
import 'package:myday/provider/theme_mode_provider.dart';
import 'package:myday/view/add_view.dart';
import 'package:myday/view/detail_view.dart';
import 'package:home_widget/home_widget.dart';
import 'package:myday/view/info_view.dart';

const String appGroupId = 'group.mydayWidget';
const String iOSWidgetName = 'MyDayWidget';
const String androidWidgetName = 'MyDayWidget';

void updateDay({required int i, Day? data, int? diff}) {
  HomeWidget.saveWidgetData<String>('title$i', data?.title);
  HomeWidget.saveWidgetData<String>('day$i', data != null ? (data.getType == DayType.ANNIVERSARY ? "D+$diff" : "D-$diff") : null);
  HomeWidget.saveWidgetData<String>(
      'date$i', data != null ? DateFormat("yyyy년 MM월 dd일 (E)").format(DateTime.fromMillisecondsSinceEpoch(data.date)) : null);
  HomeWidget.updateWidget(
    iOSName: iOSWidgetName,
    androidName: androidWidgetName,
  );
}

class MyDayView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeWidget.setAppGroupId(appGroupId);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => InfoView()));
            },
            icon: Icon(Icons.info_outline),
          ),
          IconButton(
            onPressed: () {
              context.read<ThemeModeProvider>().changeMode();
            },
            icon: Icon(context.watch<ThemeModeProvider>().isDark ? Icons.dark_mode : Icons.light_mode),
          ),
        ],
      ),
      body: BlocBuilder<DayBloc, DayState>(
        builder: (BuildContext context, DayState state) {
          if (state is EmptyDataState) {
            return const Center(
              child: Text(
                "새로운 일정을 등록해보세요.",
                textAlign: TextAlign.center,
              ),
            );
          }
          if (state is LoadingState) {
            return const CircularProgressIndicator();
          }
          if (state is ErrorState) {
            return Center(
              child: Text(
                "에러가 발생했습니다.\n다시 시도해주세요.\n\n${state.message}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is LoadedState) {
            if (state.dayList.isEmpty) {
              return const Center(
                child: Text(
                  "새로운 일정을 등록해보세요.",
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, idx) {
                return const Divider();
              },
              itemCount: state.dayList.length,
              itemBuilder: (context, idx) {
                final day = state.dayList[idx];

                if (day.widget > 0) {
                  updateDay(i: day.widget, data: day, diff: day.diff);
                }

                return ListTile(
                  key: Key('$idx ${day.hashCode}'),
                  // minLeadingWidth: 0,
                  // minVerticalPadding: 0,
                  horizontalTitleGap: 5.w,
                  leading: IconButton(
                    icon: Icon(day.widget == 1
                        ? Icons.looks_one_outlined
                        : day.widget == 2
                            ? Icons.looks_two_outlined
                            : Icons.check_box_outline_blank),
                    onPressed: () async {
                      ///check : widget 1 and widget 2
                      int widget1 = state.dayList.indexWhere((element) => element.widget == 1);
                      int widget2 = state.dayList.indexWhere((element) => element.widget == 2);
                      bool refresh = true;

                      if (day.widget > 0) {
                        updateDay(i: day.widget);

                        day.widget = 0;
                        BlocProvider.of<DayBloc>(context).add(UpdateDayListEvent(day: day));
                      } else if (day.widget == 0) {
                        if (widget1 == -1) {
                          day.widget = 1;
                          BlocProvider.of<DayBloc>(context).add(UpdateDayListEvent(day: day));

                          updateDay(i: day.widget, data: day, diff: day.diff);
                        } else if (widget2 == -1) {
                          day.widget = 2;
                          BlocProvider.of<DayBloc>(context).add(UpdateDayListEvent(day: day));

                          updateDay(i: day.widget, data: day, diff: day.diff);
                        } else {
                          refresh = false;
                        }
                      }
                    },
                  ),
                  title: Text(day.title),
                  subtitle: Text(DateFormat("yyyy.MM.dd").format(DateTime.fromMillisecondsSinceEpoch(day.date))),
                  trailing: Text(day.getType == DayType.ANNIVERSARY ? "D+${day.diff}" : "D-${day.diff}"),
                  onTap: () async {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => DetailView(data: state.dayList[idx], diff: day.diff!)));
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddView()));
        },
        child: Icon(
          Icons.event,
          color: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}

/*ListTile(
key: Key('$idx ${day.hashCode}'),
title: Text(day.title),
subtitle: Text(DateFormat("yyyy.MM.dd").format(DateTime.fromMillisecondsSinceEpoch(day.date))),
trailing: Text(""),
onTap: () async {*if
if (_globalKey.currentContext != null) {
var path = await HomeWidget.renderFlutterWidget(
const LineChart(),
key: 'filename',
logicalSize: _globalKey.currentContext!.size!,
pixelRatio:
MediaQuery.of(_globalKey.currentContext!).devicePixelRatio,
) as String;
setState(() {
imagePath = path;
});
}
Center(
// New: Add this key
key: _globalKey,
child: const LineChart(),
),
// updateDay(getDayList()[Random().nextInt(getDayList().length - 1)]);
Navigator.push(context, MaterialPageRoute(builder: (_) => ViewDetail(data: dayList[idx])));
},
);*/
