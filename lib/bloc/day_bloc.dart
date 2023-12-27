import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myday/bloc/day_event.dart';
import 'package:myday/model/day.dart';
import 'package:myday/repository/day_repository.dart';
import 'package:myday/bloc/day_state.dart';

class DayBloc extends Bloc<DayEvent, DayState> {
  final DayRepository repository;

  DayBloc({
    required this.repository,
  }) : super(EmptyDataState()) {
    on<GetDayListEvent>((_, emit) => _getDaylistEvent());
    on<CreateDayListEvent>((event, _) => _createDayListEvent(event.day));
    on<UpdateDayListEvent>((event, _) => _updateDayListEvent(event.day));
    on<DeleteDayListEvent>((event, _) => _deleteDayListEvent(event.id));
  }

  Future<void> _getDaylistEvent() async {
    try {
      // 로딩 상태 반환 [스트림 처리]
      emit(LoadingState());

      final dayList = await repository.getAllDays();

      emit(LoadedState(dayList: dayList));
    } catch (ex) {
      emit(ErrorState(message: ex.toString()));
    }
  }

  Future<void> _createDayListEvent(Day day) async {
    try {
      // 현재 상태가 로드 완료 상태 일때만 데이터 추가
      if (state is LoadedState == false) return;

      // 현재 상태
      final loadedState = (state as LoadedState);

      /// fake 데이터 [실제 서버에 요청전 결과 데이터를 빠르게 보여주기 위해]
      /// 임시로 새로 만들어진 데이터를 바로 추가해서 스트림 전송
      final fakeDayList = [
        ...loadedState.dayList,
        day,
      ];

      emit(LoadedState(dayList: fakeDayList));

      await repository.insertDay(day);
      await _getDaylistEvent();

      final loadedState2 = (state as LoadedState);
      emit(LoadedState(
        dayList: [
          ...loadedState2.dayList,
        ],
      ));
    } catch (ex) {
      emit(ErrorState(message: ex.toString()));
    }
  }

  Future<void> _updateDayListEvent(Day day) async {
    try {
      // 현재 상태가 로드 완료 상태 일때만 데이터 추가
      if (state is LoadedState == false) return;

      // 현재 상태
      final loadedState = (state as LoadedState);

      /// fake 데이터 [실제 서버에 요청전 결과 데이터를 빠르게 보여주기 위해]
      /// 임시로 새로 만들어진 데이터를 바로 추가해서 스트림 전송
      int idx = loadedState.dayList.indexWhere((element) => element.id == day.id);
      loadedState.dayList[idx] = day;
      final fakeDayList = [
        ...loadedState.dayList,
      ];
      emit(LoadedState(dayList: fakeDayList));

      await repository.updateDay(day);
      await _getDaylistEvent();

      final loadedState2 = (state as LoadedState);
      emit(LoadedState(
        dayList: [
          ...loadedState2.dayList,
        ],
      ));
    } catch (ex) {
      emit(ErrorState(message: ex.toString()));
    }
  }

  Future<void> _deleteDayListEvent(int id) async {
    try {
      // 현재 상태가 로드 완료 상태 일때만 데이터 삭제
      if (state is LoadedState == false) return;

      // 현재 상태
      final loadedState = (state as LoadedState);

      /// fake 데이터 [실제 서버에 요청전 결과 데이터를 빠르게 보여주기 위해]
      /// 로컬에서 먼저 삭제처리 후 스트림 전송
      final currentDayList = [
        ...loadedState.dayList,
      ];
      final fakeDayList =
      currentDayList.where((item) => item.id != id).toList();
      emit(LoadedState(dayList: fakeDayList));

      await repository.deleteDayById(id);
      await _getDaylistEvent();

      final loadedState2 = (state as LoadedState);
      emit(LoadedState(
        dayList: [
          ...loadedState2.dayList,
        ],
      ));
    } catch (ex) {
      emit(ErrorState(message: ex.toString()));
    }
  }
}
