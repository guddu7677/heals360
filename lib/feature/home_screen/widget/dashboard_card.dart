import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hells360/core/constant/app_textstyle.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "DASHBOARD".tr()  ,
                style: AppTextStyle.black14semibold.copyWith(
                  color: Colors.green,
                  letterSpacing: 1,
                ),
              ),
              const Icon(Icons.speed, color: Colors.green)
            ],
          ),

          const SizedBox(height: 12),

           Text("• Health Summary".tr()),
           Text("• Metrics Overview".tr()),
           Text("• Track & Notifications".tr()),
        ],
      ),
    );
  }
}