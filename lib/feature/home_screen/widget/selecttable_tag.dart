import 'package:flutter/material.dart';
import 'package:hells360/core/constant/app_colors.dart';
import 'package:hells360/core/constant/app_textstyle.dart';

class SelectableTag extends StatelessWidget {
  final String       label;
  final bool         selected;
  final VoidCallback onTap;
  
  const SelectableTag({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.10)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.inputBorder,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(Icons.check, color: AppColors.primary, size: 15),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTextStyle.black14semibold.copyWith(
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}