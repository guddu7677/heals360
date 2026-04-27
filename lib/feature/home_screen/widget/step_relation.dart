import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hells360/app_cache/profile_chache.dart';
import 'package:hells360/core/helper/profile_helper.dart';
import 'package:hells360/feature/home_screen/widget/radio_chip.dart';

class StepRelationship extends StatelessWidget {
  final ProfileData            data;
  final TextEditingController  marriageYearCtrl;
  final TextEditingController  ttcYearCtrl;
  final VoidCallback           onChanged;

  const StepRelationship({
    super.key,
    required this.data,
    required this.marriageYearCtrl,
    required this.ttcYearCtrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Relationship Info'.tr()),
          labeledField(
            label: 'Are you married? *'.tr(),
            child: Row(
              children: [
                RadioChip(
                  label: 'Yes'.tr(),
                  selected: data.married == true,
                  onTap: () {
                    data.married = true;
                    onChanged();
                  },
                ),
                const SizedBox(width: 12),
                RadioChip(
                  label: 'No'.tr(),
                  selected: data.married == false,
                  onTap: () {
                    data.married = false;
                    onChanged();
                  },
                ),
              ],
            ),
          ),
          labeledField(
            label: 'Year of Marriage'.tr(),
            child: TextField(
              controller: marriageYearCtrl,
              decoration: profileInputDeco('e.g. 2018'.tr(), icon: Icons.calendar_today_outlined),
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
          ),
          labeledField(
            label: 'Trying to Conceive Since (Year)'.tr(),
            child: TextField(
              controller: ttcYearCtrl,
              decoration: profileInputDeco('e.g. 2021'.tr(), icon: Icons.favorite_border_rounded),
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
          ),
        ],
      ),
    );
  }
}