import 'package:client/models/todo_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        isUploaded INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('todo.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //Create
  Future<Todos> addTodo(
      {required String title, required String description}) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'description': description,'isUploaded':0};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return Todos(id: id, title: title, description: description,isUploaded: 0);
  }

  //Read all
  Future<List<Todos>> getAllTodos() async {
    final db = await SQLHelper.db();
    final response = await db.query('items', orderBy: 'id');
    final resObj = response.map((resObj) => Todos.fromJson(resObj)).toList();
    return resObj;
  }

  //Read one
  static Future<List<Todos>> getItem(int id) async {
    final db = await SQLHelper.db();

    final response =
        await db.query('items', where: "id = ?", whereArgs: [id], limit: 1);

    final resObj = response.map((resObj) => Todos.fromJson(resObj)).toList();
    return resObj;
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  Future<void> deleteTodo({required int id}) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
