class User {
  int id;
  String name;
  List<Task> tasks;

  User({
    required this.id,
    required this.name,
    this.tasks = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      tasks: [], // tasks пока пустой
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}

class Task {
  int id;
  int userId;
  String description;

  Task({
    required this.id,
    required this.userId,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'description': description,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['userId'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'description': description,
    };
  }
}
