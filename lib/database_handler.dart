import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int id;
  final String username;
  final String password;

  User({this.id, this.username, this.password});

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
      return db.execute("CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT");
    },
    version: 1,
  );

});

Future<void> insertUser(User user) async {
  final Database db = await database;


  await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

final admin = User(
  id: 0,
  username: 'admin',
  password: 'admin',
);
