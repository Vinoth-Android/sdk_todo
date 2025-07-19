import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/strings.dart';
import '../../../utils/helpers/snackbar_helper.dart';
import '../controllers/theme_controller.dart';
import '../controllers/todo_controller.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/priority_selector.dart';
import '../widgets/category_selector.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TodoController _todoController = Get.find<TodoController>();
  final XThemeController _themeController = Get.find<XThemeController>();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  int _selectedPriority = 2;

  bool _isLoading = false;

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
        await _todoController.addTodo(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          date: _selectedDate,
          category: _selectedCategory,
          priority: _selectedPriority,
        );

        // Navigate back first
        Get.back();

        // Show success message after navigation
        Future.delayed(Duration(milliseconds: 200), () {
          SnackbarHelper.showSuccess(XString.taskCreatedSuccessfully);
        });
      } catch (e) {
        SnackbarHelper.showError(XString.failedToCreateTask);
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XThemeController>(
      builder: (themeController) {
        return Scaffold(
          backgroundColor: themeController.backgroundColor,
          appBar: CustomAppBar(title: XString.addTask),
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
                    hint: XString.enterDescription,
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

                  // Submit Button
                  CustomButton(
                    text: XString.createTask,
                    onPressed: _submitForm,
                    isLoading: _isLoading,
                    icon: Icons.add_task,
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
