import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hells360/app_cache/profile_chache.dart';
import 'package:hells360/core/constant/app_colors.dart';
import 'package:hells360/core/constant/app_textstyle.dart';
import 'package:hells360/core/helper/profile_helper.dart';
import 'package:hells360/feature/home_screen/widget/gender_card.dart';
import 'package:hells360/feature/home_screen/widget/selectable_row.dart';
import 'package:hells360/feature/home_screen/widget/selecttable_tag.dart';
import 'package:hells360/feature/home_screen/widget/step_goal.dart';
import 'package:hells360/feature/home_screen/widget/step_relation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileData _data;
  bool _loading = true;

  final _pageController     = PageController();
  int  _currentPage         = 0;
  static const _totalPages  = 6;

  // text controllers
  final _nameCtrl         = TextEditingController();
  final _phoneCtrl        = TextEditingController();
  final _emailCtrl        = TextEditingController();
  final _marriageYearCtrl = TextEditingController();
  final _ttcYearCtrl      = TextEditingController();
  final _goalCtrl         = TextEditingController();
  final _issueOtherCtrl   = TextEditingController();
  final _triedOtherCtrl   = TextEditingController();

  static final _stepLabels = [
    'Basic Details'.tr(),
    'Gender'.tr(),
    'Relationship'.tr(),
    'Primary Issues'.tr(),
    "What You've Tried".tr(),
    'Your Goal'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _data = await ProfileData.load();
    _nameCtrl.text         = _data.fullName;
    _phoneCtrl.text        = _data.phone;
    _emailCtrl.text        = _data.email;
    _marriageYearCtrl.text = _data.marriageYear;
    _ttcYearCtrl.text      = _data.ttcYear;
    _goalCtrl.text         = _data.goal;
    setState(() => _loading = false);

    // resume from last saved step
    if (_data.completedStep > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(_data.completedStep);
        setState(() => _currentPage = _data.completedStep);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _marriageYearCtrl.dispose();
    _ttcYearCtrl.dispose();
    _goalCtrl.dispose();
    _issueOtherCtrl.dispose();
    _triedOtherCtrl.dispose();
    super.dispose();
  }

  // ── navigation ───────────────────────────────────────────────────────────

  void _next() {
    _syncControllers();
    if (_currentPage >= _totalPages - 1) { _finish(); return; }
    if (_data.completedStep < _currentPage) _data.completedStep = _currentPage;
    _data.save();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage++);
  }

  void _back() {
    if (_currentPage == 0) { Navigator.pop(context); return; }
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage--);
  }

  void _syncControllers() {
    _data.fullName     = _nameCtrl.text.trim();
    _data.phone        = _phoneCtrl.text.trim();
    _data.email        = _emailCtrl.text.trim();
    _data.marriageYear = _marriageYearCtrl.text.trim();
    _data.ttcYear      = _ttcYearCtrl.text.trim();
    _data.goal         = _goalCtrl.text.trim();
  }

  Future<void> _finish() async {
    _syncControllers();
    _data.isComplete    = true;
    _data.completedStep = _totalPages - 1;
    await _data.save();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved successfully!',),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _ProfileHeader(
            currentPage: _currentPage,
            totalPages : _totalPages,
            stepLabel  : _stepLabels[_currentPage],
            onBack     : _back,
          ),
          _ProgressBar(
            progress: (_currentPage + 1) / _totalPages,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: [
                StepBasicDetails(
                  nameCtrl : _nameCtrl,
                  phoneCtrl: _phoneCtrl,
                  emailCtrl: _emailCtrl,
                ),
                StepGender(
                  data     : _data,
                  onChanged: () => setState(() {}),
                ),
                StepRelationship(
                  data            : _data,
                  marriageYearCtrl: _marriageYearCtrl,
                  ttcYearCtrl     : _ttcYearCtrl,
                  onChanged       : () => setState(() {}),
                ),
                StepIssues(
                  data     : _data,
                  otherCtrl: _issueOtherCtrl,
                  onChanged: () => setState(() {}),
                ),
                StepTried(
                  data     : _data,
                  otherCtrl: _triedOtherCtrl,
                  onChanged: () => setState(() {}),
                ),
                StepGoal(goalCtrl: _goalCtrl),
              ],
            ),
          ),
          _NavButton(
            isLast: _currentPage == _totalPages - 1,
            onTap : _next,
          ),
        ],
      ),
    );
  }
}

// ── sub-widgets (screen-private, not reused elsewhere) ────────────────────────

class _ProfileHeader extends StatelessWidget {
  final int    currentPage;
  final int    totalPages;
  final String stepLabel;
  final VoidCallback onBack;

  const _ProfileHeader({
    required this.currentPage,
    required this.totalPages,
    required this.stepLabel,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top   : MediaQuery.of(context).padding.top + 8,
        left  : 20,
        right : 20,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft : Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Profile Completion'.tr(),
                    style: AppTextStyle.displaySmall
                        .copyWith(color: Colors.white)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Step ${currentPage + 1}/$totalPages'.tr(),
                  style: AppTextStyle.white14
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(stepLabel,
              style: AppTextStyle.white14
                  .copyWith(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${(progress * 100).toInt()}% Complete'.tr(),
            style: AppTextStyle.primary13semibold,
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value          : progress,
              minHeight      : 8,
              backgroundColor: AppColors.divider,
              valueColor     : const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final bool         isLast;
  final VoidCallback onTap;
  const _NavButton({required this.isLast, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
      child: SizedBox(
        width : double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient    : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow   : const [
              BoxShadow(
                  color : AppColors.shadow,
                  blurRadius: 12,
                  offset: Offset(0, 4)),
            ],
          ),
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor    : Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLast ? 'Save Profile'.tr() : 'Continue'.tr(),
                  style: AppTextStyle.white16bold,
                ),
                const SizedBox(width: 8),
                Icon(
                  isLast
                      ? Icons.check_circle_outline
                      : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size : 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class GoalSuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const GoalSuggestionChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: AppTextStyle.primary13semibold,
        ),
      ),
    );
  }
}



class StepBasicDetails extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;

  const StepBasicDetails({
    super.key,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.emailCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Tell us about you'.tr()),
          labeledField(
            label: 'Full Name *',
            child: TextField(
              controller: nameCtrl,
              decoration: profileInputDeco('Enter your full name'.tr()  , icon: Icons.person_outline),
              textCapitalization: TextCapitalization.words,
            ),
          ),
          labeledField(
            label: 'Phone Number *',
            child: TextField(
              controller: phoneCtrl,
              decoration: profileInputDeco('10-digit mobile number'.tr() , icon: Icons.phone_outlined),
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),
          ),
          labeledField(
            label: 'Email ID (optional)',
            child: TextField(
              controller: emailCtrl,
              decoration: profileInputDeco('Your email address'.tr(), icon: Icons.mail_outline),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 4),
          const PrivacyNote(),
        ],
      ),
    );
  }
}

class StepGender extends StatelessWidget {
  final ProfileData  data;
  final VoidCallback onChanged;

  const StepGender({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Select your gender'.tr()),
          Text(
            'This helps us show you the most relevant health insights.'.tr(),
            style: AppTextStyle.grey14.copyWith(height: 1.5),
          ),
          const SizedBox(height: 28),
          GenderCard(
            label: 'Male'.tr(),
            icon: Icons.male_rounded,
            selected: data.gender == 'male'.tr(),
            onTap: () {
              data.gender = 'male'.tr();
              onChanged();
            },
          ),
          const SizedBox(height: 16),
          GenderCard(
            label: 'Female'.tr(),
            icon: Icons.female_rounded,
            selected: data.gender == 'female'.tr(),
            onTap: () {
              data.gender = 'female'.tr();
              onChanged();
            },
          ),
        ],
      ),
    );
  }
}


class StepIssues extends StatelessWidget {
  final ProfileData            data;
  final TextEditingController  otherCtrl;
  final VoidCallback           onChanged;

  const StepIssues({
    super.key,
    required this.data,
    required this.otherCtrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = data.issueOptions;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Primary Concerns'.tr()),
          Text('Select all that apply to you:'.tr(), style: AppTextStyle.grey14),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options
                .map(
                  (opt) => SelectableTag(
                    label: opt,
                    selected: data.issues.contains(opt),
                    onTap: () {
                      if (data.issues.contains(opt)) {
                        data.issues.remove(opt);
                      } else {
                        data.issues.add(opt);
                      }
                      onChanged();
                    },
                  ),
                )
                .toList(),
          ),
          if (data.issues.contains('Other'.tr())) ...[
            const SizedBox(height: 20),
            labeledField(
              label: 'Please specify'.tr(),
              child: TextField(
                controller: otherCtrl,
                decoration: profileInputDeco('Describe your concern...'.tr()),
                maxLines: 2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}


class StepTried extends StatelessWidget {
  final ProfileData            data;
  final TextEditingController  otherCtrl;
  final VoidCallback           onChanged;

  const StepTried({
    super.key,
    required this.data,
    required this.otherCtrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = data.triedOptions;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('What Have You Tried?'.tr()),
          Text(
            'Select all treatments or approaches you have already tried:'.tr(),
            style: AppTextStyle.grey14.copyWith(height: 1.5),
          ),
          const SizedBox(height: 16),
          ...options.map(
            (opt) => SelectableRow(
              label: opt,
              selected: data.tried.contains(opt),
              onTap: () {
                if (data.tried.contains(opt)) {
                  data.tried.remove(opt);
                } else {
                  data.tried.add(opt);
                }
                onChanged();
              },
            ),
          ),
          if (data.tried.contains('Other'.tr())) ...[
            const SizedBox(height: 4),
            labeledField(
              label: 'Please specify'.tr(),
              child: TextField(
                controller: otherCtrl,
                decoration: profileInputDeco('What else have you tried?'.tr()),
                maxLines: 2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}