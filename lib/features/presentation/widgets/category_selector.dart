import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/fonts.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/strings.dart';
import '../../../utils/helpers/snackbar_helper.dart';
import '../controllers/theme_controller.dart';
import '../controllers/todo_controller.dart';

class CategorySelector extends StatefulWidget {
  final String? selectedCategory;
  final Function(String?) onCategoryChanged;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.find<TodoController>();

    return GetBuilder<XThemeController>(
      builder: (themeController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              XString.category,
              style: TextStyle(
                fontFamily: XFonts.poppins,
                fontSize: XSizes.textSizeMd,
                fontWeight: FontWeight.w500,
                color: themeController.textColor,
              ),
            ),
            SizedBox(height: XSizes.spacingSm),

            // Category Dropdown
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: XSizes.paddingMd),
              decoration: BoxDecoration(
                color:
                    themeController.isLightTheme
                        ? Colors.grey[50]
                        : Colors.grey[800],
                borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: Builder(
                  builder: (context) {
                    final categories = todoController.getAllCategories();

                    // Check if selectedCategory exists in the current categories list
                    final validSelectedCategory =
                        widget.selectedCategory != null &&
                                widget.selectedCategory!.isNotEmpty &&
                                categories.contains(widget.selectedCategory)
                            ? widget.selectedCategory
                            : null;

                    return DropdownButton<String>(
                      value: validSelectedCategory,
                      hint: Text(
                        widget.selectedCategory != null &&
                                widget.selectedCategory!.isNotEmpty &&
                                !categories.contains(widget.selectedCategory)
                            ? widget
                                .selectedCategory! // Show the new category name as hint
                            : 'Select category (optional)',
                        style: TextStyle(
                          fontFamily: XFonts.poppins,
                          fontSize: XSizes.textSizeMd,
                          color:
                              widget.selectedCategory != null &&
                                      widget.selectedCategory!.isNotEmpty &&
                                      !categories.contains(
                                        widget.selectedCategory,
                                      )
                                  ? themeController
                                      .textColor // Show as normal text if it's a new category
                                  : themeController.textColor.withValues(
                                    alpha: 0.5,
                                  ),
                        ),
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: themeController.textColor.withValues(alpha: 0.7),
                      ),
                      isExpanded: true,
                      style: TextStyle(
                        fontFamily: XFonts.poppins,
                        fontSize: XSizes.textSizeMd,
                        color: themeController.textColor,
                      ),
                      dropdownColor: themeController.backgroundColor,
                      items: [
                        // No category option
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            'No category',
                            style: TextStyle(
                              fontFamily: XFonts.poppins,
                              fontSize: XSizes.textSizeMd,
                              color: themeController.textColor.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ),

                        // Existing categories
                        ...categories.map(
                          (category) => DropdownMenuItem<String>(
                            value: category,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: XColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: XSizes.spacingSm),
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontFamily: XFonts.poppins,
                                    fontSize: XSizes.textSizeMd,
                                    color: themeController.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Add new category option
                        DropdownMenuItem<String>(
                          value: '__add_new_category__',
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 16,
                                color: XColors.primaryColor,
                              ),
                              SizedBox(width: XSizes.spacingSm),
                              Text(
                                'Add new category',
                                style: TextStyle(
                                  fontFamily: XFonts.poppins,
                                  fontSize: XSizes.textSizeMd,
                                  color: XColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == '__add_new_category__') {
                          _showAddCategoryDialog(context, themeController);
                        } else {
                          widget.onCategoryChanged(value);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddCategoryDialog(
    BuildContext context,
    XThemeController themeController,
  ) {
    final TextEditingController categoryController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: themeController.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
        ),
        title: Text(
          XString.addNewCategory,
          style: TextStyle(
            fontFamily: XFonts.poppins,
            fontSize: XSizes.textSizeLg,
            fontWeight: FontWeight.w600,
            color: themeController.textColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                fontFamily: XFonts.poppins,
                fontSize: XSizes.textSizeMd,
                color: themeController.textColor,
              ),
              decoration: InputDecoration(
                hintText: 'Enter category name',
                hintStyle: TextStyle(
                  fontFamily: XFonts.poppins,
                  fontSize: XSizes.textSizeMd,
                  color: themeController.textColor.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor:
                    themeController.isLightTheme
                        ? Colors.grey[50]
                        : Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(XSizes.borderRadiusMd),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(XSizes.borderRadiusMd),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(XSizes.borderRadiusMd),
                  borderSide: BorderSide(color: XColors.primaryColor, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: XSizes.paddingMd,
                  vertical: XSizes.paddingSm,
                ),
              ),
              onSubmitted: (value) {
                final categoryName = value.trim();
                if (categoryName.isNotEmpty) {
                  // Check if category already exists
                  final TodoController todoController =
                      Get.find<TodoController>();
                  final existingCategories = todoController.getAllCategories();

                  if (existingCategories.contains(categoryName)) {
                    SnackbarHelper.showWarning(XString.categoryAlreadyExists);
                    return;
                  }

                  // Add category to controller first
                  todoController.addCategory(categoryName);

                  widget.onCategoryChanged(categoryName);
                  Get.back();

                  // Force rebuild to show new category
                  setState(() {});

                  // Show success message
                  SnackbarHelper.showSuccess(
                    'Category "$categoryName" added successfully!',
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              XString.cancel,
              style: TextStyle(
                fontFamily: XFonts.poppins,
                color: themeController.textColor.withValues(alpha: 0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final categoryName = categoryController.text.trim();
              if (categoryName.isNotEmpty) {
                // Check if category already exists
                final TodoController todoController =
                    Get.find<TodoController>();
                final existingCategories = todoController.getAllCategories();

                if (existingCategories.contains(categoryName)) {
                  SnackbarHelper.showWarning('This category already exists!');
                  return;
                }

                // Add category to controller first
                todoController.addCategory(categoryName);

                widget.onCategoryChanged(categoryName);
                Get.back();

                // Force rebuild to show new category
                setState(() {});
                // Show success message
                SnackbarHelper.showSuccess(
                  'Category "$categoryName" added successfully!',
                );
              } else {
                SnackbarHelper.showError(XString.pleaseEnterCategoryName);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: XColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(XSizes.borderRadiusMd),
              ),
            ),
            child: Text(
              XString.add,
              style: TextStyle(
                fontFamily: XFonts.poppins,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
