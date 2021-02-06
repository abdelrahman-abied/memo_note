import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future database() async {
    final databasepath = await getDatabasesPath();
    return openDatabase(join(databasepath, 'memo_database.db'),
        onCreate: (database, version) {
      return database.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY ,title TEXT,content TEXT,imagePath TEXT)');
    }, version: 1);
  }

  static Future<List<Map<String, dynamic>>> getNotesFromDB() async {
    final database = await DatabaseHelper.database();
    return database.query("notes", orderBy: "id DESC");
  }

  static Future insert(Map<String, Object> data) async {
    final database = await DatabaseHelper.database();
    return database.query("notes", orderBy: "id DESC");
  }

  static Future delete(int id) async {
    final database = await DatabaseHelper.database();

    return database.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
