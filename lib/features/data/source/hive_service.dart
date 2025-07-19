import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../model/todo_model.dart';

/// Service class that handles all Hive database operations for todos
/// Provides CRUD operations and manages database initialization
class HiveService {
  static const String _todoBoxName = 'todos';
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  Box<Todo>? _todoBox;

  /// Initialize Hive and register adapters
  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // Register the Todo adapter if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TodoAdapter());
    }

    try {
      // Open the Todo box
      _todoBox = await Hive.openBox<Todo>(_todoBoxName);
    } catch (e) {
      // If there's an error opening the box, try to delete it and recreate
      debugPrint('Error opening Todo box: $e');
      await Hive.deleteBoxFromDisk(_todoBoxName);
      _todoBox = await Hive.openBox<Todo>(_todoBoxName);
    }
  }

  /// Add a new Todo
  Future<String> addTodo(Todo todo) async {
    if (_todoBox == null) {
      debugPrint('Warning: Trying to add todo but Hive not initialized');
      // Try to initialize Hive again
      await init();
      if (_todoBox == null) {
        throw Exception('Failed to initialize Hive for adding todo');
      }
    }

    // Generate a unique ID if not provided
    if (todo.id.isEmpty) {
      todo = todo.copyWith(id: const Uuid().v4());
    }

    try {
      await _todoBox!.put(todo.id, todo);
      return todo.id;
    } catch (e) {
      debugPrint('Error adding todo: $e');
      throw Exception('Failed to add todo: $e');
    }
  }

  /// Get a Todo by ID
  Todo? getTodo(String id) {
    if (_todoBox == null) {
      throw Exception('Hive not initialized');
    }

    return _todoBox!.get(id);
  }

  /// Get all Todos
  List<Todo> getAllTodos() {
    if (_todoBox == null) {
      debugPrint('Warning: Hive not initialized in getAllTodos');
      return []; // Return empty list instead of throwing exception
    }

    try {
      return _todoBox!.values.toList();
    } catch (e) {
      debugPrint('Error getting todos: $e');
      return []; // Return empty list on error
    }
  }

  /// Get all Todos for a specific date
  List<Todo> getTodosByDate(DateTime date) {
    if (_todoBox == null) {
      throw Exception('Hive not initialized');
    }

    return _todoBox!.values
        .where(
          (todo) =>
              todo.date.year == date.year &&
              todo.date.month == date.month &&
              todo.date.day == date.day,
        )
        .toList();
  }

  /// Update a Todo
  Future<void> updateTodo(Todo todo) async {
    if (_todoBox == null) {
      throw Exception('Hive not initialized');
    }

    await _todoBox!.put(todo.id, todo);
  }

  /// Delete a Todo
  Future<void> deleteTodo(String id) async {
    if (_todoBox == null) {
      throw Exception('Hive not initialized');
    }

    await _todoBox!.delete(id);
  }

  /// Delete all Todos
  Future<void> deleteAllTodos() async {
    if (_todoBox == null) {
      throw Exception('Hive not initialized');
    }

    await _todoBox!.clear();
  }

  /// Get Todos by category
  List<Todo> getTodosByCategory(String category) {
    if (_todoBox == null) {
      throw Exception('Hive not initialized');
    }

    return _todoBox!.values.where((todo) => todo.category == category).toList();
  }

  /// Get completed Todos
  List<Todo> getCompletedTodos() {
    if (_todoBox == null) {
      throw Exception('Hive not initialized');
    }

    return _todoBox!.values.where((todo) => todo.isCompleted).toList();
  }

  /// Get incomplete Todos
  List<Todo> getIncompleteTodos() {
    if (_todoBox == null) {
      throw Exception('Hive not initialized');
    }

    return _todoBox!.values.where((todo) => !todo.isCompleted).toList();
  }

  /// Get Todos by priority
  List<Todo> getTodosByPriority(int priority) {
    if (_todoBox == null) {
      throw Exception('Hive not initialized');
    }

    return _todoBox!.values.where((todo) => todo.priority == priority).toList();
  }

  /// Get Todos with reminders
  List<Todo> getTodosWithReminders() {
    if (_todoBox == null) {
      throw Exception('Hive not initialized');
    }

    return _todoBox!.values.where((todo) => todo.reminderTime != null).toList();
  }

  /// Get a stream of the Todo box
  Stream<BoxEvent> watchTodos() {
    if (_todoBox == null) {
      throw Exception('Hive not initialized');
    }

    return _todoBox!.watch();
  }

  /// Close the Hive box
  Future<void> close() async {
    await _todoBox?.close();
  }
}
