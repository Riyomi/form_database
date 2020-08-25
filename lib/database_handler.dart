import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int id;
  final String username;
  final String password;

  User(this.id, this.username, this.password);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
        "CREATE TABLE users("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "username TEXT NOT NULL,"
            "password TEXT NOT NULL)",
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

Future<void> updateUser(User user, String newUsername) async {
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
      maps[i]['id'],
      maps[i]['username'],
      maps[i]['password'],
    );
  });
}

Future<bool> doUserAndPasswordMatch(String username, String password) async {
  final db = await database;

  var res = await db.query('users',
    where: "username = ? AND password = ?",
    whereArgs: [username, password],
  );

  return res.isNotEmpty ? true : false ;
}

Future<bool> getUserByUsername(String username) async {
  final db = await database;

  var res = await db.query('users',
    columns: ["id", "username", "password"],
    where: "username = ?",
    whereArgs: [username],
  );

  return res.isNotEmpty ? true : false;
}

Future<bool> updateUserName(String username, String newUserName) async {
  final db = await database;
  
  var res = await db.rawUpdate('UPDATE users SET username = ? WHERE username = ?', [newUserName, username]);

  if (res > 0) {
    return true;
  }
  return false;
}