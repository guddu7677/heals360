import 'package:flutter/material.dart';
import 'package:hells360/core/constant/app_theme.dart';
import 'package:hells360/feature/home_screen/widget/dashboard_card.dart';
import 'package:hells360/feature/home_screen/widget/profile_complation_banner.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
      Size get size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background ,
      body: Column(
        children: [
         const SafeArea(child: const ProfileCompletionBanner()),


          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  DashboardCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}