import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hells360/core/constant/app_colors.dart';
import 'package:hells360/core/constant/app_textstyle.dart';
import 'package:hells360/core/helper/profile_helper.dart';
import 'package:hells360/feature/home_screen/view/profile_screen.dart';


class StepGoal extends StatelessWidget {
  final TextEditingController goalCtrl;

  const StepGoal({super.key, required this.goalCtrl});

  static final _suggestions = [
    'Conceive naturally'.tr(),
    'Avoid IVF'.tr(),
    'Improve my reports'.tr(),
    'Understand root cause'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Your Biggest Goal'.tr()),
          Text(
            'What do you most want to achieve right now?'.tr(),
            style: AppTextStyle.grey14.copyWith(height: 1.5),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: goalCtrl,
            decoration: profileInputDeco(
              'Type your goal here...'.tr() ,
              icon: Icons.emoji_objects_outlined,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Text('Quick suggestions:'.tr(), style: AppTextStyle.grey14semibold),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions
                .map(
                  (s) => GoalSuggestionChip(
                    label: s,
                    onTap: () => goalCtrl.text = s,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          _CompletionNote(),
        ],
      ),
    );
  }
}

class _CompletionNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primary.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children:   [
              Icon(Icons.verified_outlined, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'Almost there!'.tr(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Our specialists will personalise your care plan based on your answers. Tap "Save Profile" to complete.'.tr(),
            style: AppTextStyle.grey13,
          ),
        ],
      ),
    );
  }
}