import 'package:myday/db/db.dart';
import 'package:myday/model/day.dart';
import 'package:sqflite/sqflite.dart';

class DayDao {
  Future<int> createDay(Day day) async {
    final db = await DB().db;
    return await db.insert(
      dayTable, // table name
      day.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Day>> getDays() async {
    final db = await DB().db;
    final List<Map<String, dynamic>> maps = await db.query(dayTable);

    return List.generate(
      maps.length,
          (index) => Day(
        id: maps[index]['id'] as int,
        title: maps[index]['title'] as String,
        type: maps[index]['type'] as int,
        date: maps[index]['date'] as int,
        period: maps[index]['period'],
        widget: maps[index]['widget'],
      ),
    );
  }

  Future<int> updateDay(Day day) async {
    final db = await DB().db;
    return await db.update(
      dayTable, // table n
      day.toMap(), // new post row data post row data
      where: 'id = ?',
      whereArgs: [day.id],
    );
  }

  Future<int> deleteDay(int id) async {
    final db = await DB().db;
    await db.delete(
      dayTable, // table name
      where: 'id = ?',
      whereArgs: [id],
    );

    return id;
  }

  Future<int> deleteDays(List ids) async {
    final db = await DB().db;
    String where = 'id IN (${List.filled(ids.length, '?').join(',')})';

    return await db
        .delete(
      dayTable, // table name
      where: where,
      whereArgs: ids,
    );
  }
}
