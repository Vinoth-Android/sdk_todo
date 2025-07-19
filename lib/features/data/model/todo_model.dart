import 'package:hive/hive.dart';

part 'todo_model.g.dart';

/// Todo model class that represents a task in the application
/// Uses Hive for local database storage with auto-generated adapter
@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String? category;

  @HiveField(6)
  int? priority; // Priority levels: 1=Low, 2=Medium, 3=High

  @HiveField(7)
  DateTime? reminderTime;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  @HiveField(10)
  int? sortOrder;

  Todo({
    required this.id,
    required this.name,
    required this.description,
    this.isCompleted = false,
    required this.date,
    this.category,
    this.priority = 2, // Default to medium priority
    this.reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.sortOrder,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Create a copy of the Todo with updated fields
  Todo copyWith({
    String? id,
    String? name,
    String? description,
    bool? isCompleted,
    DateTime? date,
    String? category,
    int? priority,
    DateTime? reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sortOrder,
  }) {
    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  // Convert Todo to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isCompleted': isCompleted,
      'date': date.millisecondsSinceEpoch,
      'category': category,
      'priority': priority,
      'reminderTime': reminderTime?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'sortOrder': sortOrder,
    };
  }

  // Create a Todo from a Map
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      category: map['category'],
      priority: map['priority'],
      reminderTime:
          map['reminderTime'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['reminderTime'])
              : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      sortOrder: map['sortOrder'],
    );
  }
}
