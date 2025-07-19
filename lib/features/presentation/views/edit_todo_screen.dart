import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/strings.dart';
import '../../../utils/helpers/snackbar_helper.dart';
import '../../data/model/todo_model.dart';
import '../controllers/theme_controller.dart';
import '../controllers/todo_controller.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/priority_selector.dart';
import '../widgets/category_selector.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;

  const EditTodoScreen({super.key, required this.todo});

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final TodoController _todoController = Get.find<TodoController>();
  final XThemeController _themeController = Get.find<XThemeController>();

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  late DateTime _selectedDate;
  late String? _selectedCategory;
  late int _selectedPriority;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with existing todo data
    _nameController = TextEditingController(text: widget.todo.name);
    _descriptionController = TextEditingController(
      text: widget.todo.description,
    );
    _selectedDate = widget.todo.date;
    _selectedCategory = widget.todo.category;
    _selectedPriority = widget.todo.priority ?? 2;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final updatedTodo = widget.todo.copyWith(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          date: _selectedDate,
          category: _selectedCategory,
          priority: _selectedPriority,
        );

        await _todoController.updateTodo(updatedTodo);

        // Navigate back first
        Get.back();

        // Show success message after navigation
        Future.delayed(Duration(milliseconds: 200), () {
          SnackbarHelper.showSuccess('Task updated successfully!');
        });
      } catch (e) {
        SnackbarHelper.showError('Failed to update task. Please try again.');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _themeController.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _deleteTask() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: _themeController.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
        ),
        title: Text(
          XString.deleteTaskTitle,
          style: TextStyle(color: _themeController.textColor),
        ),
        content: Text(
          XString.deleteTaskMessage,
          style: TextStyle(color: _themeController.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              XString.cancel,
              style: TextStyle(color: _themeController.primaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(XString.delete, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _todoController.deleteTodo(widget.todo.id);
        Get.back();
        SnackbarHelper.showSuccess(XString.taskDeletedSuccessfully);
      } catch (e) {
        SnackbarHelper.showError(XString.failedToDeleteTask);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XThemeController>(
      builder: (themeController) {
        return Scaffold(
          backgroundColor: themeController.backgroundColor,
          appBar: CustomAppBar(
            title: XString.editTask,
            actions: [
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.white),
                onPressed: _deleteTask,
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(XSizes.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Name Field
                  CustomTextField(
                    controller: _nameController,
                    label: XString.taskName,
                    hint: XString.enterTaskName,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return XString.pleaseEnterTaskName;
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: XSizes.spacingLg),

                  // Description Field
                  CustomTextField(
                    controller: _descriptionController,
                    label: XString.description,
                    hint: 'Enter task description (optional)',
                    maxLines: 3,
                  ),

                  SizedBox(height: XSizes.spacingLg),

                  // Date Picker
                  CustomTextField(
                    controller: TextEditingController(
                      text: DateFormat('MMM d, yyyy').format(_selectedDate),
                    ),
                    label: XString.dueDate,
                    hint: XString.selectDueDate,
                    isRequired: true,
                    readOnly: true,
                    onTap: _selectDate,
                    prefixIcon: Icon(
                      Icons.calendar_today_outlined,
                      color: themeController.primaryColor,
                      size: 20,
                    ),
                  ),

                  SizedBox(height: XSizes.spacingLg),

                  // Priority Selector
                  PrioritySelector(
                    selectedPriority: _selectedPriority,
                    onPriorityChanged: (priority) {
                      setState(() => _selectedPriority = priority);
                    },
                  ),

                  SizedBox(height: XSizes.spacingLg),

                  // Category Selector
                  CategorySelector(
                    selectedCategory: _selectedCategory,
                    onCategoryChanged: (category) {
                      setState(() => _selectedCategory = category);
                    },
                  ),

                  SizedBox(height: XSizes.spacingXl * 2),

                  // Action Buttons
                  Row(
                    children: [
                      // Update Button
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          text: XString.update,
                          onPressed: _submitForm,
                          isLoading: _isLoading,
                          icon: Icons.update,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: XSizes.spacingLg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
