import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../data/model/todo_model.dart';
import '../../data/source/hive_service.dart';
import '../../../utils/constants/strings.dart';
import '../../../utils/helpers/snackbar_helper.dart';

/// Main controller that manages todo operations and state
/// Handles CRUD operations, filtering, sorting, and category management
class TodoController extends GetxController {
  final HiveService _hiveService = HiveService();

  // Observable lists
  final RxList<Todo> _todos = <Todo>[].obs;
  final RxList<Todo> _filteredTodos = <Todo>[].obs;

  // Categories list - separate from todos to persist added categories
  final RxList<String> _categories = <String>[].obs;

  // Selected date for filtering
  final Rx<DateTime> _selectedDate = DateTime.now().obs;

  // Selected category for filtering
  final RxString _selectedCategory = ''.obs;

  // Task status filter: 'all', 'completed', 'incomplete'
  final RxString _statusFilter = 'all'.obs;

  // Loading state
  final RxBool _isLoading = false.obs;

  // Getters
  List<Todo> get todos => _todos;
  List<Todo> get filteredTodos => _filteredTodos;
  List<String> get categories => _categories;
  DateTime get selectedDate => _selectedDate.value;
  String get selectedCategory => _selectedCategory.value;
  String get statusFilter => _statusFilter.value;
  bool get isLoading => _isLoading.value;

  // Formatted selected date
  String get formattedSelectedDate =>
      DateFormat('EEEE, MMMM d, y').format(_selectedDate.value);

  @override
  void onInit() {
    super.onInit();
    _initHive();
  }

  Future<void> _initHive() async {
    _isLoading.value = true;
    try {
      // Try to initialize Hive if not already initialized
      try {
        await _hiveService.init();
      } catch (e) {
        debugPrint('Hive initialization error: $e');
      }

      await loadTodos();
      await _loadCategories();
    } catch (e) {
      debugPrint('Error in _initHive: $e');
      SnackbarHelper.showError(
        'Failed to initialize database: ${e.toString()}',
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Load all todos
  Future<void> loadTodos() async {
    _isLoading.value = true;
    try {
      try {
        final todos = _hiveService.getAllTodos();
        _todos.assignAll(todos);
        _applyFilters();
        await _updateCategoriesFromTodos();
      } catch (e) {
        debugPrint('Error loading todos: $e');
        _todos.clear();
        _filteredTodos.clear();
      }
    } catch (e) {
      debugPrint('Unexpected error in loadTodos: $e');
      SnackbarHelper.showError('Failed to load todos: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  // Add a new todo
  Future<void> addTodo({
    required String name,
    required String description,
    required DateTime date,
    String? category,
    int? priority,
    DateTime? reminderTime,
  }) async {
    _isLoading.value = true;
    try {
      // Get the next sort order
      final nextSortOrder = _getNextSortOrder();

      final todo = Todo(
        id: const Uuid().v4(),
        name: name,
        description: description,
        date: date,
        category: category,
        priority: priority ?? 2,
        reminderTime: reminderTime,
        sortOrder: nextSortOrder,
      );

      // Add the todo to our local list first for immediate UI update
      _todos.add(todo);
      _applyFilters();

      try {
        // Then try to save it to Hive
        await _hiveService.addTodo(todo);
        await loadTodos(); // Refresh from database

        SnackbarHelper.showSuccess(XString.todoAddedSuccessfully);
      } catch (e) {
        debugPrint('Error saving todo to Hive: $e');
        // Remove from local list if saving failed
        _todos.removeWhere((t) => t.id == todo.id);
        _applyFilters();
        rethrow;
      }
    } catch (e) {
      debugPrint('Error in addTodo: $e');
      SnackbarHelper.showError('Failed to add todo: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  // Update a todo
  Future<void> updateTodo(Todo todo) async {
    _isLoading.value = true;
    try {
      // Update the updatedAt timestamp
      final updatedTodo = todo.copyWith(updatedAt: DateTime.now());
      await _hiveService.updateTodo(updatedTodo);
      await loadTodos();

      SnackbarHelper.showSuccess(XString.taskUpdatedSuccessfully);
    } catch (e) {
      SnackbarHelper.showError('Failed to update todo: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  // Toggle todo completion status
  Future<void> toggleTodoStatus(Todo todo) async {
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    await updateTodo(updatedTodo);
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    _isLoading.value = true;
    try {
      await _hiveService.deleteTodo(id);
      await loadTodos();

      SnackbarHelper.showSuccess(XString.taskDeletedSuccessfully);
    } catch (e) {
      SnackbarHelper.showError('Failed to delete todo: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  // Set selected date for filtering
  void setSelectedDate(DateTime date) {
    _selectedDate.value = date;
    _applyFilters();
  }

  // Set selected category for filtering
  void setSelectedCategory(String category) {
    _selectedCategory.value = category;
    _applyFilters();
  }

  // Set status filter
  void setStatusFilter(String status) {
    _statusFilter.value = status;
    _applyFilters();
  }

  // Reorder todos with persistence
  Future<void> reorderTodos(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    try {
      // Get the current filtered list
      final List<Todo> currentFiltered = List.from(_filteredTodos);

      // Move the item in the filtered list
      final Todo item = currentFiltered.removeAt(oldIndex);
      currentFiltered.insert(newIndex, item);

      // Update sort orders for all affected items
      for (int i = 0; i < currentFiltered.length; i++) {
        final updatedTodo = currentFiltered[i].copyWith(sortOrder: i);
        await _hiveService.updateTodo(updatedTodo);

        // Update in the main todos list as well
        final mainIndex = _todos.indexWhere((t) => t.id == updatedTodo.id);
        if (mainIndex != -1) {
          _todos[mainIndex] = updatedTodo;
        }
      }

      // Update the filtered list
      _filteredTodos.assignAll(currentFiltered);
    } catch (e) {
      debugPrint('Error reordering todos: $e');
      // Reload todos to restore original order on error
      await loadTodos();
    }
  }

  // Apply filters (date, category, and status)
  void _applyFilters() {
    try {
      if (_todos.isEmpty) {
        _filteredTodos.clear();
        return;
      }

      List<Todo> filtered =
          _todos.toList(); // Create a copy to avoid modifying the original

      // Apply date filter
      filtered =
          filtered
              .where(
                (todo) =>
                    todo.date.year == _selectedDate.value.year &&
                    todo.date.month == _selectedDate.value.month &&
                    todo.date.day == _selectedDate.value.day,
              )
              .toList();

      // Apply status filter
      switch (_statusFilter.value) {
        case 'completed':
          filtered = filtered.where((todo) => todo.isCompleted).toList();
          break;
        case 'incomplete':
          filtered = filtered.where((todo) => !todo.isCompleted).toList();
          break;
        case 'all':
        default:
          // No additional filtering needed for 'all'
          break;
      }

      // Apply category filter if selected
      if (_selectedCategory.value.isNotEmpty) {
        filtered =
            filtered
                .where((todo) => todo.category == _selectedCategory.value)
                .toList();
      }

      // Sort by custom sort order first, then by priority and name
      if (filtered.isNotEmpty) {
        filtered.sort((a, b) {
          // First sort by custom sort order if available
          if (a.sortOrder != null && b.sortOrder != null) {
            return a.sortOrder!.compareTo(b.sortOrder!);
          } else if (a.sortOrder != null) {
            return -1; // a comes first
          } else if (b.sortOrder != null) {
            return 1; // b comes first
          }

          // Then sort by priority (high to low)
          final priorityComparison = (b.priority ?? 0).compareTo(
            a.priority ?? 0,
          );
          if (priorityComparison != 0) {
            return priorityComparison;
          }

          // Finally sort by name (alphabetically)
          return a.name.compareTo(b.name);
        });
      }

      _filteredTodos.assignAll(filtered);
    } catch (e) {
      debugPrint('Error applying filters: $e');
      _filteredTodos.clear(); // Reset to empty list on error
    }
  }

  // Get all unique categories
  List<String> getAllCategories() {
    try {
      // Return the maintained categories list
      final sortedCategories = List<String>.from(_categories);
      sortedCategories.sort();

      // Ensure there are no duplicates or special values that might conflict
      if (sortedCategories.contains('__add_new_category__')) {
        sortedCategories.remove('__add_new_category__');
      }

      return sortedCategories;
    } catch (e) {
      debugPrint('Error getting categories: $e');
      return []; // Return empty list on error
    }
  }

  // Add a new category
  void addCategory(String category) {
    if (category.isNotEmpty && !_categories.contains(category)) {
      _categories.add(category);
      _saveCategories();
      update(); // Trigger UI update
    }
  }

  // Load categories from SharedPreferences
  Future<void> _loadCategories() async {
    try {
      final prefs = Get.find<SharedPreferences>();
      final categoriesJson = prefs.getStringList('categories') ?? [];
      _categories.assignAll(categoriesJson);
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  // Save categories to SharedPreferences
  Future<void> _saveCategories() async {
    try {
      final prefs = Get.find<SharedPreferences>();
      await prefs.setStringList('categories', _categories.toList());
    } catch (e) {
      debugPrint('Error saving categories: $e');
    }
  }

  // Update categories from existing todos (merge with saved categories)
  Future<void> _updateCategoriesFromTodos() async {
    try {
      // Get categories from todos
      final todoCategories =
          _todos
              .where(
                (todo) => todo.category != null && todo.category!.isNotEmpty,
              )
              .map((todo) => todo.category!)
              .toSet()
              .toList();

      // Merge with existing categories
      final allCategories =
          <String>{..._categories, ...todoCategories}.toList();

      if (allCategories.length != _categories.length) {
        _categories.assignAll(allCategories);
        await _saveCategories();
      }
    } catch (e) {
      debugPrint('Error updating categories from todos: $e');
    }
  }

  // Get todos count by priority
  Map<int, int> getTodoCountByPriority() {
    final Map<int, int> counts = {1: 0, 2: 0, 3: 0};

    for (final todo in _filteredTodos) {
      final priority = todo.priority ?? 2;
      if (counts.containsKey(priority)) {
        counts[priority] = counts[priority]! + 1;
      }
    }

    return counts;
  }

  // Get completion percentage for filtered todos
  double getCompletionPercentage() {
    if (_filteredTodos.isEmpty) return 0.0;

    final completedCount =
        _filteredTodos.where((todo) => todo.isCompleted).length;

    return completedCount / _filteredTodos.length;
  }

  // Get the next sort order for new todos
  int _getNextSortOrder() {
    if (_todos.isEmpty) return 0;

    // Find the maximum sort order and add 1
    int maxSortOrder = -1;
    for (final todo in _todos) {
      if (todo.sortOrder != null && todo.sortOrder! > maxSortOrder) {
        maxSortOrder = todo.sortOrder!;
      }
    }

    return maxSortOrder + 1;
  }

  @override
  void onClose() {
    _hiveService.close();
    super.onClose();
  }
}
