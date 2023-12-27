import 'package:myday/dao/day_dao.dart';
import 'package:myday/model/day.dart';

class DayRepository {
  final dayDao = DayDao();

  Future getAllDays() => dayDao.getDays();

  Future insertDay(Day day) => dayDao.createDay(day);

  Future updateDay(Day day) => dayDao.updateDay(day);

  Future deleteDayById(int id) => dayDao.deleteDay(id);

  Future deleteDayByIds(List<int> ids) => dayDao.deleteDays(ids);
}
