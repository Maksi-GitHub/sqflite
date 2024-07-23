import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_sqflite/models/models.dart';

class DatabaseInitialized {
  static final DatabaseInitialized instance = DatabaseInitialized._init();
  static Database? _database;

  DatabaseInitialized._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('my_db2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER,
      description TEXT,
      FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
    )
    ''');
  }

  Future<int> saveUser(User user) async {
    final db = await instance.database;
    try {
      return await db.insert('users', user.toMap());
    } catch (e) {
      print("Ошибка при сохранении пользователя: $e");
      return -1;
    }
  }

  Future<int> saveTask(Task task) async {
    final db = await instance.database;
    try {
      return await db.insert('tasks', task.toMap());
    } catch (e) {
      print("Ошибка при сохранении задачи: $e");
      return -1;
    }
  }

  // Future<List<Map<String, dynamic>>> fetchUsersTasks() async {
  //   final db = await instance.database;

  //   final result = await db.rawQuery('''
  //   SELECT
  //     users.id as userId,
  //     users.name,
  //     tasks.id as taskId,
  //     tasks.userId,
  //     tasks.description
  //   FROM users
  //   LEFT JOIN tasks ON users.id = tasks.userId
  // ''');

  //   Map<int, Map<String, dynamic>> userMap = {};

  //   for (var row in result) {
  //     final userId = row['userId'] as int;

  //           if (!userMap.containsKey(userId)) {
  //       userMap[userId] = {
  //         'id': userId,
  //         'name': row['name'] as String,
  //         'tasks': []
  //       };
  //     }

  //     if (row['taskId'] != null) {
  //       final task = {
  //         'id': row['taskId'] as int,
  //         'userId': userId,
  //         'description': row['description'] as String,
  //       };

  //       userMap[userId]!['tasks'].add(task);
  //     }
  //   }

  //   return userMap.values.toList();
  // }

  Future<List<User>> fetchUsersTasks() async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT
        users.id as userId,
        users.name,
        tasks.id as taskId,
        tasks.userId,
        tasks.description
      FROM users
      LEFT JOIN tasks ON users.id = tasks.userId
    ''');

    Map<int, User> userMap = {};

    for (var row in result) {
      final userId = row['userId'] as int;

      if (!userMap.containsKey(userId)) {
        userMap[userId] = User(
          id: userId,
          name: row['name'] as String,
          tasks: [],
        );
      }

      if (row['taskId'] != null) {
        final task = Task(
          id: row['taskId'] as int,
          userId: userId,
          description: row['description'] as String,
        );

        userMap[userId]!.tasks.add(task);
      }
    }

    return userMap.values.toList();
  }

  Future<List<User>> fetchUsers() async {
    final db = await instance.database;
    final result = await db.query('users');

    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<List<Task>> fetchTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');

    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
