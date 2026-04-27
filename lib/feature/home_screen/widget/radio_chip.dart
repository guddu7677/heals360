import 'package:flutter/material.dart';
import 'package:hells360/core/constant/app_colors.dart';
import 'package:hells360/core/constant/app_textstyle.dart';

class RadioChip extends StatelessWidget {
  final String       label;
  final bool         selected;
  final VoidCallback onTap;

  const RadioChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.inputBorder,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyle.black16semibold.copyWith(
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}