import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/fonts.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/theme_controller.dart';

class PrioritySelector extends StatelessWidget {
  final int selectedPriority;
  final Function(int) onPriorityChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  static const List<String> priorityLabels = ['Low', 'Medium', 'High'];
  static const List<Color> priorityColors = [
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XThemeController>(
      builder: (themeController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              'Priority *',
              style: TextStyle(
                fontFamily: XFonts.poppins,
                fontSize: XSizes.textSizeMd,
                fontWeight: FontWeight.w500,
                color: themeController.textColor,
              ),
            ),
            SizedBox(height: XSizes.spacingSm),

            // Priority Options
            Row(
              children: List.generate(3, (index) {
                final priority = index + 1;
                final isSelected = selectedPriority == priority;
                final color = priorityColors[index];
                final label = priorityLabels[index];

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < 2 ? XSizes.spacingSm : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => onPriorityChanged(priority),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: XSizes.paddingMd,
                          horizontal: XSizes.paddingSm,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? color.withValues(alpha: 0.1)
                                  : themeController.isLightTheme
                                  ? Colors.grey[100]
                                  : Colors.grey[800],
                          borderRadius: BorderRadius.circular(
                            XSizes.borderRadiusLg,
                          ),
                          border: Border.all(
                            color:
                                isSelected
                                    ? color
                                    : Colors.grey.withValues(alpha: 0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? color
                                        : color.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child:
                                  isSelected
                                      ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                      : null,
                            ),
                            SizedBox(height: XSizes.spacingXs),
                            Text(
                              label,
                              style: TextStyle(
                                fontFamily: XFonts.poppins,
                                fontSize: XSizes.textSizeSm,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    isSelected
                                        ? color
                                        : themeController.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
