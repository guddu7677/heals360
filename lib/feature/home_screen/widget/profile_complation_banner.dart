import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hells360/app_cache/profile_chache.dart';
import 'package:hells360/core/constant/app_colors.dart';
import 'package:hells360/core/constant/app_textstyle.dart';
import 'package:hells360/feature/home_screen/view/profile_screen.dart' hide AppColors;

class ProfileCompletionBanner extends StatefulWidget {
  const ProfileCompletionBanner({super.key});

  @override
  State<ProfileCompletionBanner> createState() =>
      _ProfileCompletionBannerState();
}

class _ProfileCompletionBannerState extends State<ProfileCompletionBanner> {
  ProfileData? _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await ProfileData.load();
    if (mounted) setState(() => _data = d);
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null) return const SizedBox.shrink();

    return _data!.isComplete ? _CompleteBanner() : _IncompleteBanner(
      data: _data!,
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        _load(); 
      },
    );
  }
}

class _CompleteBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile Complete!'.tr(),
                    style: AppTextStyle.success14.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text('Your personalised plan is being prepared.'.tr(),
                    style: AppTextStyle.grey12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncompleteBanner extends StatelessWidget {
  final ProfileData  data;
  final VoidCallback onTap;

  const _IncompleteBanner({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pct = (data.progress * 100).toInt();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Complete your profile'.tr(),
                          style: AppTextStyle.white16bold),
                      const SizedBox(height: 2),
                      Text('Get a personalised fertility care plan'.tr(),
                          style: AppTextStyle.white12italic),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text('$pct%',
                          style: AppTextStyle.white14.copyWith(
                              fontWeight: FontWeight.w700, fontSize: 13)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: data.progress,
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.25),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$pct% done — tap to continue'.tr() ,
              style: AppTextStyle.white12italic,
            ),
          ],
        ),
      ),
    );
  }
}