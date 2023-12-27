import 'package:myday/data/globals.dart';
import 'package:myday/model/day.dart';
import 'package:myday/data/notice.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


final String dayTable = 'day';
final String noticeTable = 'notice';
class DB {
  DB._privateConstructor();

  static final DB _instance = DB._privateConstructor();

  factory DB() {
    return _instance;
  }

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;

    _db = await _open();
    return _db!;
  }

  Future _open() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'myday.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  _onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = ON");
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $dayTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        type INTEGER NOT NULL,
        date INTEGER NOT NULL,
        period INTEGER,
        widget INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $noticeTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        d_id INTEGER NOT NULL,
        day_type INTEGER NOT NULL,
        noti_type INTEGER,
        date INTEGER NOT NULL,
        use INTEGER NOT NULL,
        FOREIGN KEY(d_id) REFERENCES $dayTable(id)
      )
    ''');
  }

  /// notification db
  Future addNoti(Notice item) async {
    Database db = await _instance.db;
    return await db.insert(
      noticeTable, // table name
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future updateNotice(Notice item) async {
    Database db = await _instance.db;
    await db.update(
      noticeTable, // table n
      item.toMap(), // new post row data post row data
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future getNotices() async {
    Database db = await _instance.db;
    final List<Map<String, dynamic>> maps = await db.query(noticeTable);

    return List.generate(
        maps.length,
        (index) => Notice(
              id: maps[index]['id'] as int,
              dId: maps[index]['d_id'] as int,
              dayType: maps[index]['day_type'] as int,
              notiType: maps[index]['noti_type'],
              date: maps[index]['date'] as int,
              use: maps[index]['use'] as int,
            ));
  }

  Future<List<Notice>> findNoticeWithId(int dId) async {
    Database db = await _instance.db;
    final List<Map<String, dynamic>> maps = await db.query(noticeTable,
        columns: ['id', 'd_id', 'day_type', 'noti_type', 'date', 'use'],
        where: 'd_id = ?',
        whereArgs: [dId],
        orderBy: 'date DESC');

    return List.generate(
        maps.length,
        (index) => Notice(
              id: maps[index]['id'] as int,
              dId: maps[index]['d_id'] as int,
              dayType: maps[index]['day_type'] as int,
              notiType: maps[index]['noti_type'],
              date: maps[index]['date'] as int,
              use: maps[index]['use'] as int,
            ));
  }

  Future findNoticeWithType(int dId, int noti_type) async {
    Database db = await _instance.db;
    final List<Map<String, dynamic>> maps = await db.query(noticeTable,
        columns: ['id', 'd_id', 'day_type', 'noti_type', 'date', 'use'],
        where: 'd_id = ? AND noti_type = ?',
        whereArgs: [dId, noti_type]);

    return List.generate(
        maps.length,
        (index) => Notice(
              id: maps[index]['id'] as int,
              dId: maps[index]['d_id'] as int,
              dayType: maps[index]['day_type'] as int,
              notiType: maps[index]['noti_type'],
              date: maps[index]['date'] as int,
              use: maps[index]['use'] as int,
            ));
  }

  Future<int> removeNotice(int id) async {
    Database db = await _instance.db;
    await db.delete(
      noticeTable, // table name
      where: 'id = ?',
      whereArgs: [id],
    );

    return id;
  }

  Future removeNotices(List ids) async {
    Database db = await _instance.db;
    String where = 'id IN (${List.filled(ids.length, '?').join(',')})';

    await db.delete(
      noticeTable, // table name
      where: where,
      whereArgs: ids,
    );
  }

  Future close() async {
    Database db = await _instance.db;
    db.close();
  }
}
