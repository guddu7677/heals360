import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hells360/core/constant/app_colors.dart';
import 'package:hells360/core/constant/app_textstyle.dart';

Widget sectionTitle(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(text, style: AppTextStyle.displaySmall),
    );

Widget labeledField({required String label, required Widget child}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr(),
          style: AppTextStyle.grey14semibold.copyWith(letterSpacing: 0.3),
        ),
        const SizedBox(height: 6),
        child,
        const SizedBox(height: 16),
      ],
    );

InputDecoration profileInputDeco(String hint, {IconData? icon}) => InputDecoration(
      hintText: hint.tr(),
      hintStyle: AppTextStyle.hint13,
      filled: true,
      fillColor: AppColors.inputFill,
      prefixIcon: icon != null
          ? Icon(icon, color: AppColors.primary, size: 20)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );

class PrivacyNote extends StatelessWidget {
  const PrivacyNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        children:  [
          Icon(Icons.lock_outline, color: AppColors.primary, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your data is private & secure. We never share it without your permission.'.tr(),
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}