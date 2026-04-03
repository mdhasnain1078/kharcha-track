import 'package:flutter/material.dart';
import 'package:finance_tracker/core/constants/app_constants.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';

class GoalIconPicker extends StatelessWidget {
  final int selectedIconIndex;
  final int selectedColorIndex;
  final ValueChanged<int> onIconSelected;

  const GoalIconPicker({
    super.key,
    required this.selectedIconIndex,
    required this.selectedColorIndex,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: AppConstants.goalIcons.asMap().entries.map((entry) {
        final isSelected = entry.key == selectedIconIndex;
        return GestureDetector(
          onTap: () => onIconSelected(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppConstants.goalColors[selectedColorIndex].withOpacity(0.15)
                  : (isDark ? AppColors.darkCard : AppColors.surface),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppConstants.goalColors[selectedColorIndex]
                    : (isDark ? AppColors.darkBorder : AppColors.border),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              entry.value,
              size: 24,
              color: isSelected
                  ? AppConstants.goalColors[selectedColorIndex]
                  : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
            ),
          ),
        );
      }).toList(),
    );
  }
}
