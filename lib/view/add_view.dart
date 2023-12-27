import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:myday/bloc/day_bloc.dart';
import 'package:myday/bloc/day_event.dart';
import 'package:myday/data/enums.dart';
import 'package:myday/data/globals.dart';
import 'package:myday/model/day.dart';
import 'package:myday/db/db.dart';
import 'package:myday/provider/add_provider.dart';
import 'package:myday/util/toast_util.dart';
import 'package:myday/widget/my_container.dart';

class AddView extends StatefulWidget {
  bool edit;
  Day? data;

  AddView({super.key, this.edit = false, this.data});

  @override
  State<StatefulWidget> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  late DateTime minDate, maxDate, initDate;

  @override
  void initState() {
    // TODO: implement initState
    minDate = DateTime(1900, 01, 01);
    maxDate = DateTime(DateTime.now().year + 100, 12, 31);
    initDate = DateTime.now();
    context.read<AddProvider>().initDate(initDate);

    if (widget.edit) {
      initDate = widget.data!.getDate;
      context.read<AddProvider>().setEditDay(widget.data!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              if (context.read<AddProvider>().isSave) {
                if (widget.edit) {
                  if (context.read<AddProvider>().isDifference) {
                    BlocProvider.of<DayBloc>(context).add(UpdateDayListEvent(day: context.read<AddProvider>().getDay));
                  }
                } else {
                  BlocProvider.of<DayBloc>(context).add(CreateDayListEvent(day: context.read<AddProvider>().getDay));
                }

                context.read<AddProvider>().clear();

                if (!mounted) return;
                Navigator.pop(context);
              } else {
                if (context.read<AddProvider>().title.isEmpty) {
                  MyToast().showToast("제목을 입력해주세요.");
                } else if (context.read<AddProvider>().type == null) {
                  MyToast().showToast("타입을 입력해주세요.");
                } else if (context.read<AddProvider>().date == null) {
                  MyToast().showToast("날짜를 입력해주세요.");
                } else if (context.read<AddProvider>().type != null &&
                    context.read<AddProvider>().type!.isPeriod &&
                    context.read<AddProvider>().period == null) {
                  MyToast().showToast("주기를 입력해주세요.");
                }
              }
            },
            child: Text(
              "저장",
              style: TextStyle(color: context.watch<AddProvider>().isSave ? null : Colors.grey),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: MyContainer(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 1,
                      child: Text(
                        "제목",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                    flex: 9,
                    child: TextField(
                      controller: TextEditingController()..text = context.watch<AddProvider>().title,
                      onChanged: (String value) {
                        context.read<AddProvider>().setTitle(value);
                        if (value.isEmpty) {
                          context.read<AddProvider>().setType(null);
                          context.read<AddProvider>().setDate(null);
                          context.read<AddProvider>().setPeriod(null);
                        }
                      },
                    ),
                  )
                ],
              ),
              10.verticalSpace,
              if (context.watch<AddProvider>().title.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "타입",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        flex: 6,
                        child: Text(
                          context.watch<AddProvider>().type != null ? context.watch<AddProvider>().type!.text : "선택 안함",
                          textAlign: TextAlign.center,
                        )),
                    Expanded(
                      flex: 3,
                      child: OutlinedButton(
                        child: Text("선택하기"),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            builder: (context) {
                              return SizedBox(
                                height: extent * DayType.values.length + 20.h,
                                child: ListView.builder(
                                  itemCount: DayType.values.length,
                                  itemExtent: extent,
                                  itemBuilder: (BuildContext context, int idx) {
                                    return ListTile(
                                      title: Text(DayType.values[idx].text),
                                      onTap: () {
                                        context.read<AddProvider>().setType(DayType.values[idx]);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              10.verticalSpace,
              if (context.watch<AddProvider>().title.isNotEmpty && context.watch<AddProvider>().type != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          context.watch<AddProvider>().type!.isPeriod
                              ? "시작일"
                              : context.watch<AddProvider>().type == DayType.BIRTHDAY
                                  ? "생년월일"
                                  : "날짜",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      flex: 5,
                      child: Text(
                        context.watch<AddProvider>().date != null
                            ? DateFormat("yyyy.MM.dd (E)").format(context.watch<AddProvider>().date!)
                            : "선택 안함",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: OutlinedButton(
                        child: const Text("선택하기"),
                        onPressed: () async {
                          await _showDatePicker();
                        },
                      ),
                    )
                  ],
                ),
              10.verticalSpace,
              if (context.watch<AddProvider>().title.isNotEmpty &&
                  context.watch<AddProvider>().type != null &&
                  context.watch<AddProvider>().type!.isPeriod &&
                  context.watch<AddProvider>().date != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "주기",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const Expanded(flex: 6, child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (String value) {
                          context.read<AddProvider>().setPeriod(int.parse(value));
                        },
                      ),
                    ),
                    20.horizontalSpace,
                    Expanded(
                        flex: 2,
                        child: Text(context.watch<AddProvider>().type! == DayType.MONTH_PERIOD
                            ? "개월 마다"
                            : context.watch<AddProvider>().type! == DayType.WEEK_PERIOD
                                ? "주 마다"
                                : "일 마다")),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  _showDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300.h,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            minimumDate: minDate,
            maximumDate: maxDate,
            initialDateTime: initDate,
            onDateTimeChanged: (DateTime value) {
              context.read<AddProvider>().setDate(value);
            },
          ),
        );
      },
    );
  }
}
