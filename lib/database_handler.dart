import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final String username;
  final String password;

  User(this.username, this.password);

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}

final _databaseName = 'user_database.db';

// Open the database and store the reference.
final Future<Database> database = getDatabasesPath().then((String path) {
  return openDatabase(
    join(path, _databaseName),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE users(username TEXT PRIMARY KEY NOT NULL, password TEXT)",
      );
    },
    version: 1,
  );

});

Future<void> insertUser(User user) async {
  final Database db = await database;

  await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
  );
}

Future<void> updateUser(User user) async {
  final db = await database;

  await db.update(
    'users',
    user.toMap(),
    where: "username = ?",
    whereArgs: [user.username], // used to safeguard against SQL injection
  );
}

Future<void> deleteUser(String username) async {
  final db = await database;

  await db.delete(
    'users',
    where: "username = ?",
    whereArgs: [username],
  );
}

Future<List<User>> users() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('users');

  return List.generate(maps.length, (i) {
    return User(
      maps[i]['username'],
      maps[i]['password'],
    );
  });
}

Future<bool> getUser(String username, String password) async {
  final db = await database;

  var res = await db.query('users',
    where: "username = ? AND password = ?",
    whereArgs: [username, password],
  );

  return res.isNotEmpty ? true : false ;

}

