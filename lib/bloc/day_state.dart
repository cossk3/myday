import 'package:myday/model/day.dart';

abstract class DayState {}

// 데이터가 없는 상태
class EmptyDataState extends DayState {}

// 데이터 로드 요청중 상태
class LoadingState extends DayState {}

// 오류발생 상태
class ErrorState extends DayState {
  final String message;

  ErrorState({
    required this.message,
  });
}

// 데이터 로드 완료 상태
class LoadedState extends DayState {
  // 로드 결과 데이터 리스트
  final List<Day> dayList;

  LoadedState({
    required this.dayList,
  });
}