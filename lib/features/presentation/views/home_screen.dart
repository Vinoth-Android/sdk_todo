import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/fonts.dart';
import '../../../utils/constants/sizes.dart';
import '../../data/model/todo_model.dart';
import '../controllers/theme_controller.dart';
import '../controllers/todo_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoController _todoController = Get.find<TodoController>();
  final ScrollController _scrollController = ScrollController();
  final RxBool _isScrolled = false.obs;

  @override
  void initState() {
    super.initState();
    // Load todos when the screen initializes
    _todoController.loadTodos();

    // Add scroll listener for header animation
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Update header visibility based on scroll position
    if (_scrollController.hasClients &&
        _scrollController.offset > 80 &&
        !_isScrolled.value) {
      _isScrolled.value = true;
    } else if (_scrollController.hasClients &&
        _scrollController.offset <= 80 &&
        _isScrolled.value) {
      _isScrolled.value = false;
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  Widget _buildThemeToggle(XThemeController themeController) {
    return GestureDetector(
      onTap: () {
        themeController.changeTheme(!themeController.isLightTheme);
      },
      child: Container(
        padding: EdgeInsets.all(XSizes.paddingSm),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(XSizes.borderRadiusCircle),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          themeController.isLightTheme
              ? Icons.dark_mode_rounded
              : Icons.light_mode_rounded,
          color: Colors.white,
          size: XSizes.iconSizeSm,
        ),
      ),
    );
  }

  Widget _buildDateSelector(XThemeController themeController) {
    return GestureDetector(
      onTap: () => _selectDate(context, themeController),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: XSizes.paddingMd,
          vertical: XSizes.paddingSm,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(XSizes.borderRadiusXl),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_outlined, color: Colors.white, size: 18),
            SizedBox(width: XSizes.spacingSm),
            Text(
              DateFormat('MMM d, yyyy').format(_todoController.selectedDate),
              style: TextStyle(
                fontFamily: XFonts.poppins,
                fontSize: XSizes.textSizeMd,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(width: XSizes.spacingSm),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    XThemeController themeController,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _todoController.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeController.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _todoController.setSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XThemeController>(
      builder: (themeController) {
        return Scaffold(
          backgroundColor: themeController.backgroundColor,
          body: NestedScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            headerSliverBuilder:
                (context, innerBoxIsScrolled) => [
                  // Beautiful minimal header
                  Obx(
                    () => SliverAppBar(
                      expandedHeight: _isScrolled.value ? 120 : 240,
                      collapsedHeight: 70,
                      pinned: true,
                      stretch: true,
                      backgroundColor: themeController.primaryColor,
                      elevation: 0,
                      leading: SizedBox.shrink(),
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      title: AnimatedOpacity(
                        opacity: _isScrolled.value ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  'SDK Todo',
                                  style: TextStyle(
                                    fontFamily: XFonts.poppins,
                                    fontSize: XSizes.textSizeLg,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: 4.0,
                              ), // Tight to right corner
                              child: _buildThemeToggle(themeController),
                            ),
                          ],
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                themeController.primaryColor,
                                themeController.primaryColor.withValues(
                                  alpha: 0.9,
                                ),
                              ],
                            ),
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                XSizes.paddingLg,
                                XSizes.paddingMd,
                                XSizes.paddingLg,
                                XSizes.paddingMd,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top row with title and theme toggle
                                  AnimatedOpacity(
                                    opacity: _isScrolled.value ? 0.0 : 1.0,
                                    duration: Duration(milliseconds: 300),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'SDK Todo',
                                          style: TextStyle(
                                            fontFamily: XFonts.poppins,
                                            fontSize: XSizes.textSize3xl,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        _buildThemeToggle(themeController),
                                      ],
                                    ),
                                  ),

                                  Spacer(),

                                  // Greeting and task count
                                  AnimatedOpacity(
                                    opacity: _isScrolled.value ? 0.0 : 1.0,
                                    duration: Duration(milliseconds: 300),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Good ${_getGreeting()}!',
                                          style: TextStyle(
                                            fontFamily: XFonts.poppins,
                                            fontSize: XSizes.textSizeXl,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white.withValues(
                                              alpha: 0.95,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: XSizes.spacingXs),
                                        Obx(
                                          () {
                                            final taskCount =
                                                _todoController
                                                    .filteredTodos
                                                    .length;
                                            final completedCount =
                                                _todoController.filteredTodos
                                                    .where(
                                                      (todo) =>
                                                          todo.isCompleted,
                                                    )
                                                    .length;
                                            return Text(
                                              '$completedCount of $taskCount tasks completed',
                                              style: TextStyle(
                                                fontFamily: XFonts.poppins,
                                                fontSize: XSizes.textSizeMd,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white.withValues(
                                                  alpha: 0.85,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: XSizes.spacingMd),

                                  // Simplified date selector
                                  AnimatedOpacity(
                                    opacity: _isScrolled.value ? 0.0 : 1.0,
                                    duration: Duration(milliseconds: 300),
                                    child: _buildDateSelector(themeController),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              slivers: [
                // Task completion progress
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      XSizes.paddingLg,
                      XSizes.paddingLg,
                      XSizes.paddingLg,
                      0,
                    ),
                    child: Obx(() {
                      final completionPercentage =
                          _todoController.getCompletionPercentage();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Task Completion',
                                style: TextStyle(
                                  fontFamily: XFonts.poppins,
                                  fontSize: XSizes.textSizeSm,
                                  fontWeight: FontWeight.w500,
                                  color: themeController.textColor,
                                ),
                              ),
                              Text(
                                '${(completionPercentage * 100).toInt()}%',
                                style: TextStyle(
                                  fontFamily: XFonts.poppins,
                                  fontSize: XSizes.textSizeSm,
                                  fontWeight: FontWeight.bold,
                                  color: XColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: XSizes.spacingXs),
                          LinearProgressIndicator(
                            value: completionPercentage,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              XColors.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(
                              XSizes.borderRadiusXs,
                            ),
                            minHeight: 5,
                          ),
                        ],
                      );
                    }),
                  ),
                ),

                // Task list header with filters
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      XSizes.paddingLg,
                      XSizes.paddingLg,
                      XSizes.paddingLg,
                      XSizes.paddingSm,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tasks',
                              style: TextStyle(
                                fontFamily: XFonts.poppins,
                                fontSize: XSizes.textSizeLg,
                                fontWeight: FontWeight.bold,
                                color: themeController.textColor,
                              ),
                            ),

                            // Category filter dropdown
                            PopupMenuButton<String>(
                              icon: Icon(
                                Icons.filter_list,
                                color: themeController.textColor,
                                size: 20,
                              ),
                              onSelected: (value) {
                                if (value == 'all') {
                                  _todoController.setSelectedCategory('');
                                } else {
                                  _todoController.setSelectedCategory(value);
                                }
                              },
                              itemBuilder: (context) {
                                final categories =
                                    _todoController.getAllCategories();
                                return [
                                  PopupMenuItem(
                                    value: 'all',
                                    child: Text(
                                      'All Categories',
                                      style: TextStyle(
                                        fontFamily: XFonts.poppins,
                                        fontSize: XSizes.textSizeSm,
                                      ),
                                    ),
                                  ),
                                  ...categories
                                      .map(
                                        (category) => PopupMenuItem(
                                          value: category,
                                          child: Text(
                                            category,
                                            style: TextStyle(
                                              fontFamily: XFonts.poppins,
                                              fontSize: XSizes.textSizeSm,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ];
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: XSizes.spacingMd),

                        // Status filter chips
                        Obx(
                          () => Row(
                            children: [
                              _buildFilterChip(
                                'All',
                                'all',
                                _todoController.statusFilter,
                                themeController,
                              ),
                              SizedBox(width: XSizes.spacingSm),
                              _buildFilterChip(
                                'Incomplete',
                                'incomplete',
                                _todoController.statusFilter,
                                themeController,
                              ),
                              SizedBox(width: XSizes.spacingSm),
                              _buildFilterChip(
                                'Completed',
                                'completed',
                                _todoController.statusFilter,
                                themeController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Task list
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: XSizes.paddingLg),
                  sliver: Obx(() {
                    final filteredTodos = _todoController.filteredTodos;
                    if (_todoController.isLoading) {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 240,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: XColors.primaryColor,
                            ),
                          ),
                        ),
                      );
                    }

                    if (filteredTodos.isEmpty) {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: themeController.height - 550,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.task_alt,
                                  size: 64,
                                  color: Color.fromRGBO(
                                    themeController.textColor.red,
                                    themeController.textColor.green,
                                    themeController.textColor.blue,
                                    0.3,
                                  ),
                                ),
                                SizedBox(height: XSizes.spacingMd),
                                Text(
                                  'No tasks for this day',
                                  style: TextStyle(
                                    fontFamily: XFonts.poppins,
                                    fontSize: XSizes.textSizeMd,
                                    color: Color.fromRGBO(
                                      themeController.textColor.red,
                                      themeController.textColor.green,
                                      themeController.textColor.blue,
                                      0.7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverToBoxAdapter(
                      child: ReorderableListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: XSizes.paddingMd),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredTodos.length,
                        onReorder: (oldIndex, newIndex) async {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          // Update the order in the controller with persistence
                          await _todoController.reorderTodos(
                            oldIndex,
                            newIndex,
                          );
                        },
                        itemBuilder: (context, index) {
                          final todo = filteredTodos[index];
                          return _buildDraggableTodoItem(
                            todo,
                            themeController,
                            index,
                          );
                        },
                      ),
                    );
                  }),
                ),

                // Bottom padding
                SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: themeController.primaryColor,
            onPressed: () => Get.toNamed('/add-todo'),
            elevation: 4,
            child: Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  // Build a beautiful draggable todo item widget
  Widget _buildDraggableTodoItem(
    Todo todo,
    XThemeController themeController,
    int index,
  ) {
    return Container(
      key: ValueKey(todo.id),
      child: _buildTodoItem(todo, themeController),
    );
  }

  // Build a beautiful todo item widget
  Widget _buildTodoItem(Todo todo, XThemeController themeController) {
    final List<Color> priorityColors = [
      Colors.green.shade400,
      Colors.amber.shade400,
      Colors.red.shade400,
    ];

    final List<String> priorityLabels = ['Low', 'Medium', 'High'];

    final priorityIndex = (todo.priority ?? 2) - 1;
    final priorityColor =
        priorityIndex >= 0 && priorityIndex < priorityColors.length
            ? priorityColors[priorityIndex]
            : priorityColors[1];

    final priorityLabel =
        priorityIndex >= 0 && priorityIndex < priorityLabels.length
            ? priorityLabels[priorityIndex]
            : priorityLabels[1];

    return Dismissible(
      key: Key(todo.id),
      background: Container(
        margin: EdgeInsets.only(bottom: XSizes.spacingMd),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade300],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: XSizes.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              todo.isCompleted
                  ? Icons.undo_rounded
                  : Icons.check_circle_rounded,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(height: 4),
            Text(
              todo.isCompleted ? 'Undo' : 'Complete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: XSizes.spacingMd),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade300],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: XSizes.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_rounded, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Left to right swipe - toggle completion
          _todoController.toggleTodoStatus(todo);
          return false; // Don't dismiss the item
        } else {
          // Right to left swipe - delete
          return await Get.dialog(
            AlertDialog(
              backgroundColor: themeController.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
              ),
              title: Text(
                'Delete Task',
                style: TextStyle(
                  fontFamily: XFonts.poppins,
                  fontSize: XSizes.textSizeLg,
                  fontWeight: FontWeight.w600,
                  color: themeController.textColor,
                ),
              ),
              content: Text(
                'Are you sure you want to delete this task?',
                style: TextStyle(
                  fontFamily: XFonts.poppins,
                  fontSize: XSizes.textSizeSm,
                  color: themeController.textColor,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: XFonts.poppins,
                      color: XColors.primaryColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        XSizes.borderRadiusMd,
                      ),
                    ),
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: XFonts.poppins,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _todoController.deleteTodo(todo.id);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: XSizes.spacingMd),
        decoration: BoxDecoration(
          color: themeController.backgroundColor,
          borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
          border: Border.all(
            color:
                themeController.isLightTheme
                    ? Colors.grey.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
            onTap: () => _showTaskDetailsBottomSheet(todo, themeController),
            child: Padding(
              padding: EdgeInsets.all(XSizes.paddingMd),
              child: Row(
                children: [
                  // Beautiful checkbox with animation
                  GestureDetector(
                    onTap: () => _todoController.toggleTodoStatus(todo),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            todo.isCompleted
                                ? priorityColor
                                : Colors.transparent,
                        border: Border.all(
                          color:
                              todo.isCompleted
                                  ? priorityColor
                                  : Colors.grey.shade400,
                          width: 2,
                        ),
                        boxShadow:
                            todo.isCompleted
                                ? [
                                  BoxShadow(
                                    color: priorityColor.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                                : null,
                      ),
                      child:
                          todo.isCompleted
                              ? Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                    ),
                  ),
                  SizedBox(width: XSizes.spacingMd),

                  // Task content with better layout
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task name with better styling
                        Text(
                          todo.name,
                          style: TextStyle(
                            fontFamily: XFonts.poppins,
                            fontSize: XSizes.textSizeMd,
                            fontWeight: FontWeight.w600,
                            color:
                                todo.isCompleted
                                    ? themeController.textColor.withValues(
                                      alpha: 0.6,
                                    )
                                    : themeController.textColor,
                            decoration:
                                todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                          ),
                        ),
                        SizedBox(height: 4),

                        // Task description
                        if (todo.description.isNotEmpty)
                          Text(
                            todo.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: XFonts.poppins,
                              fontSize: XSizes.textSizeSm,
                              color: themeController.textColor.withValues(
                                alpha: 0.7,
                              ),
                              decoration:
                                  todo.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                            ),
                          ),

                        SizedBox(height: 8),

                        // Priority badge and category
                        Row(
                          children: [
                            // Priority badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: priorityColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: priorityColor.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: priorityColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    priorityLabel,
                                    style: TextStyle(
                                      fontFamily: XFonts.poppins,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: priorityColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Category badge
                            if (todo.category != null &&
                                todo.category!.isNotEmpty) ...[
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: XColors.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: XColors.primaryColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.label,
                                      size: 10,
                                      color: XColors.primaryColor,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      todo.category!,
                                      style: TextStyle(
                                        fontFamily: XFonts.poppins,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: XColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(width: 8),
                            // Date indicator
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: XColors.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: XColors.primaryColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                DateFormat('MMM d').format(todo.date),
                                style: TextStyle(
                                  fontFamily: XFonts.poppins,
                                  fontSize: XSizes.textSizeXs,
                                  color: themeController.textColor.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Drag handle
                  Icon(
                    Icons.drag_handle,
                    color: Colors.grey.withValues(alpha: 0.5),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Show task details bottom sheet
  void _showTaskDetailsBottomSheet(
    Todo todo,
    XThemeController themeController,
  ) {
    final List<String> priorityLabels = ['Low', 'Medium', 'High'];
    final List<Color> priorityColors = [
      Colors.green,
      Colors.orange,
      Colors.red,
    ];

    final priorityIndex = (todo.priority ?? 2) - 1;
    final priorityLabel =
        priorityIndex >= 0 && priorityIndex < priorityLabels.length
            ? priorityLabels[priorityIndex]
            : priorityLabels[1]; // Default to medium priority

    final priorityColor =
        priorityIndex >= 0 && priorityIndex < priorityColors.length
            ? priorityColors[priorityIndex]
            : priorityColors[1]; // Default to medium priority color

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(XSizes.paddingLg),
        decoration: BoxDecoration(
          color: themeController.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(XSizes.borderRadiusXl),
            topRight: Radius.circular(XSizes.borderRadiusXl),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Task name and completion status
            Row(
              children: [
                Checkbox(
                  value: todo.isCompleted,
                  activeColor: XColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(XSizes.borderRadiusXs),
                  ),
                  onChanged: (value) {
                    _todoController.toggleTodoStatus(todo);
                    Get.back();
                  },
                ),
                SizedBox(width: XSizes.spacingSm),
                Expanded(
                  child: Text(
                    todo.name,
                    style: TextStyle(
                      fontFamily: XFonts.poppins,
                      fontSize: XSizes.textSizeLg,
                      fontWeight: FontWeight.bold,
                      color: themeController.textColor,
                      decoration:
                          todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: XSizes.spacingMd),

            // Priority badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: XSizes.paddingSm,
                vertical: XSizes.paddingXs,
              ),
              decoration: BoxDecoration(
                color: priorityColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(XSizes.borderRadiusMd),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    priorityIndex == 0
                        ? Icons.flag_outlined
                        : priorityIndex == 1
                        ? Icons.flag
                        : Icons.priority_high,
                    color: priorityColor,
                    size: 16,
                  ),
                  SizedBox(width: XSizes.spacingXs),
                  Text(
                    '$priorityLabel Priority',
                    style: TextStyle(
                      fontFamily: XFonts.poppins,
                      fontSize: XSizes.textSizeSm,
                      color: priorityColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: XSizes.spacingMd),

            // Date and category
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: XColors.primaryColor,
                ),
                SizedBox(width: XSizes.spacingSm),
                Text(
                  DateFormat('EEEE, MMMM d, y').format(todo.date),
                  style: TextStyle(
                    fontFamily: XFonts.poppins,
                    fontSize: XSizes.textSizeMd,
                    color: themeController.textColor,
                  ),
                ),
              ],
            ),

            if (todo.category != null && todo.category!.isNotEmpty) ...[
              SizedBox(height: XSizes.spacingSm),
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: XColors.primaryColor),
                  SizedBox(width: XSizes.spacingSm),
                  Text(
                    todo.category!,
                    style: TextStyle(
                      fontFamily: XFonts.poppins,
                      fontSize: XSizes.textSizeMd,
                      color: themeController.textColor,
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: XSizes.spacingLg),

            // Description
            Text(
              'Description',
              style: TextStyle(
                fontFamily: XFonts.poppins,
                fontSize: XSizes.textSizeMd,
                fontWeight: FontWeight.w600,
                color: themeController.textColor,
              ),
            ),
            SizedBox(height: XSizes.spacingSm),
            Text(
              todo.description,
              style: TextStyle(
                fontFamily: XFonts.poppins,
                fontSize: XSizes.textSizeMd,
                color: Color.fromRGBO(
                  themeController.textColor.red,
                  themeController.textColor.green,
                  themeController.textColor.blue,
                  0.7,
                ),
                height: 1.5,
              ),
            ),

            SizedBox(height: XSizes.spacingXl),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Delete button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await Get.dialog<bool>(
                        AlertDialog(
                          backgroundColor: themeController.backgroundColor,
                          title: Text(
                            'Delete Task',
                            style: TextStyle(
                              fontFamily: XFonts.poppins,
                              color: themeController.textColor,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to delete this task?',
                            style: TextStyle(
                              fontFamily: XFonts.poppins,
                              color: themeController.textColor,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: XFonts.poppins,
                                  color: XColors.primaryColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Get.back(result: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontFamily: XFonts.poppins,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await _todoController.deleteTodo(todo.id);
                        Get.back();
                      }
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    label: Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: XFonts.poppins,
                        color: Colors.red,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: XSizes.paddingMd),
                    ),
                  ),
                ),

                SizedBox(width: XSizes.spacingMd),

                // Edit button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      // Navigate to edit screen with todo data
                      Get.toNamed('/edit-todo', arguments: todo);
                    },
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      'Edit',
                      style: TextStyle(
                        fontFamily: XFonts.poppins,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: XColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: XSizes.paddingMd),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    String currentFilter,
    XThemeController themeController,
  ) {
    final isSelected = currentFilter == value;
    return GestureDetector(
      onTap: () => _todoController.setStatusFilter(value),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: XSizes.paddingMd,
          vertical: XSizes.paddingSm,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? XColors.primaryColor
                  : themeController.isLightTheme
                  ? Colors.grey[200]
                  : Colors.grey[700],
          borderRadius: BorderRadius.circular(XSizes.borderRadiusXl),
          border:
              isSelected
                  ? null
                  : Border.all(
                    color:
                        themeController.isLightTheme
                            ? Colors.grey[300]!
                            : Colors.grey[600]!,
                  ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: XFonts.poppins,
            fontSize: XSizes.textSizeSm,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : themeController.textColor,
          ),
        ),
      ),
    );
  }
}
