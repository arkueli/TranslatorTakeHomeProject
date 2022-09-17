import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:translator/Models/history.dart';

class DbService with ChangeNotifier {
  static const TABLE_NAME = 'history';
  late Database db;
  Future<String> _dbPath() async {
    return join(await getDatabasesPath(), 'bukkincode.db');
  }

  Future invokeDb() async {
    return db = await openDatabase(await _dbPath(), version: 3,
        onCreate: (Database db, int version) async {
      await databaseExists(await _dbPath());
      await db.execute(
          'CREATE TABLE history (id INTEGER PRIMARY KEY ,input TEXT,output TEXT NOT NULL,inputLanguage TEXT NOT NULL,outputLanguage TEXT NOT NULL)');
    });
  }

  Future insertHistory(History history) async {
    var dbInvoke = await invokeDb();
    history.id = dbInvoke.insert('history', history.toJson);
    return history;
  }

  Future<List<History>> translateHistory() async {
    Database db = await openDatabase(
      await _dbPath(),
      version: 3,
    );
    var result = await db.query(TABLE_NAME, limit: 10, orderBy: 'id');
    return result.map((e) => History.fromJson(e)).toList();
  }
}
