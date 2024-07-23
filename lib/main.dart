import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_sqflite/models/models.dart';
import 'database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DatabaseInitialized.instance;

  // User user = User(name: 'User3', id: 3);
  // int userId = await db.saveUser(user);
  // print('Добавлен пользователь с ID: $userId');

  // if (userId != -1) {
  //   Task task1 = Task(userId: userId, description: 'Task1', id: 5);
  //   Task task2 = Task(userId: userId, description: 'Task2', id: 6);

  //   await db.saveTask(task1);
  //   await db.saveTask(task2);
  //   print('Добавлены задачи $task1, $task2 для пользователя с ID: $userId');
  // }

  List<User> users = await db.fetchUsers();
  print('Все пользователи: ${jsonEncode(users.map((user) => user.toJson()).toList())}');

  List<Task> tasks = await db.fetchTasks();
  print('Все задачи: ${jsonEncode(tasks.map((task) => task.toJson()).toList())}');

  List<User> usersWithTasks = await db.fetchUsersTasks();
  print('Пользователи и их задачи: ${jsonEncode(usersWithTasks.map((user) => user.toJson()).toList())}');

  await db.close();
}
