/// Application-wide string constants
/// Centralized location for all app text to support localization
class XString {
  XString._();

  // App Info
  static const String appName = 'SDK Todo';
  static const String noRouteFound = 'No Route Found';

  // Screen Titles
  static const String addTask = 'Add Task';
  static const String editTask = 'Edit Task';
  static const String home = 'Home';

  // Button Labels
  static const String createTask = 'Create Task';
  static const String update = 'Update';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String add = 'Add';

  // Form Labels
  static const String taskName = 'Task Name';
  static const String description = 'Description';
  static const String dueDate = 'Due Date';
  static const String priority = 'Priority';
  static const String category = 'Category';

  // Form Hints
  static const String enterTaskName = 'Enter task name';
  static const String enterDescription = 'Enter task description (optional)';
  static const String selectDueDate = 'Select due date';

  // Success Messages
  static const String taskCreatedSuccessfully = 'Task created successfully!';
  static const String taskUpdatedSuccessfully = 'Task updated successfully!';
  static const String taskDeletedSuccessfully = 'Task deleted successfully!';
  static const String todoAddedSuccessfully = 'Todo added successfully';
  static const String categoryAddedSuccessfully = 'Category added successfully!';

  // Error Messages
  static const String failedToCreateTask = 'Failed to create task. Please try again.';
  static const String failedToUpdateTask = 'Failed to update task. Please try again.';
  static const String failedToDeleteTask = 'Failed to delete task. Please try again.';
  static const String pleaseEnterTaskName = 'Please enter a task name';
  static const String pleaseEnterCategoryName = 'Please enter a category name!';
  static const String categoryAlreadyExists = 'This category already exists!';
  static const String pleaseFillAllFields = 'Please fill in all required fields';

  // Dialog Messages
  static const String deleteTaskTitle = 'Delete Task';
  static const String deleteTaskMessage = 'Are you sure you want to delete this task? This action cannot be undone.';

  // Priority Levels
  static const String lowPriority = 'Low';
  static const String mediumPriority = 'Medium';
  static const String highPriority = 'High';

  // Status Filters
  static const String all = 'All';
  static const String completed = 'Completed';
  static const String incomplete = 'Incomplete';

  // General
  static const String loading = 'Loading...';
  static const String noTasksFound = 'No tasks found';
  static const String addNewCategory = 'Add New Category';
}
