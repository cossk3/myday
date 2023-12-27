import 'package:myday/model/day.dart';

abstract class DayEvent {}

class GetDayListEvent extends DayEvent {}

class CreateDayListEvent extends DayEvent {
  final Day day;

  CreateDayListEvent({required this.day});
}

class UpdateDayListEvent extends DayEvent {
  final Day day;

  UpdateDayListEvent({required this.day});
}

class DeleteDayListEvent extends DayEvent {
  final int id;

  DeleteDayListEvent({required this.id});
}
