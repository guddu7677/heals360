import 'package:flutter/material.dart';
import 'package:hells360/core/constant/app_colors.dart';
import 'package:hells360/core/constant/app_textstyle.dart';

class GenderCard extends StatelessWidget {
  final String   label;
  final IconData icon;
  final bool     selected;
  final VoidCallback onTap;

  const GenderCard({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.inputBorder,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [const BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))]
              : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : AppColors.textSecondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTextStyle.black18bold.copyWith(
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }
}