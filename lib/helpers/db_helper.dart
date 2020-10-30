import 'package:contact_diary/helpers/prefs_helper.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static const TABLE_NAME = 'contact_entries';

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(dbPath + 'contacts.db', onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $TABLE_NAME(id TEXT PRIMARY KEY, description TEXT, '
          'amount_of_people INTEGER, mask_worn INTEGER, location TEXT,'
          'distance_kept INTEGER, start_date INTEGER, end_date INTEGER)');
    }, version: 1);
  }

  static Future<void> insertData(Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(TABLE_NAME, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final autoCleanOldItems = await PrefsHelper.isAutoDeleteDataEnabled();
    if (autoCleanOldItems) {
      await cleanOldItems();
    }
    final db = await DBHelper.database();
    return db.query(TABLE_NAME);
  }

  static Future<void> updateData(Map<String, Object> item) async {
    final db = await DBHelper.database();
    db.update(TABLE_NAME, item, where: 'id = ?', whereArgs: [item['id']]);
  }

  static Future<void> deleteItem(String id) async {
    final db = await DBHelper.database();
    db.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> cleanOldItems() async {
    final db = await DBHelper.database();
    final twoWeeksAgo =
        DateTime.now().subtract(Duration(days: 14)).millisecondsSinceEpoch;
    db.delete(TABLE_NAME, where: 'start_date <= ?', whereArgs: [twoWeeksAgo]);
  }
}
