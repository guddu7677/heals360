import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hells360/core/constant/app_images.dart';
import 'package:hells360/core/constant/app_textstyle.dart';
import 'package:hells360/core/constant/app_theme.dart';
import 'package:hells360/feature/authentication/widget/primary_button.dart';
import 'package:hells360/core/utils/responsive_auth_wrapper.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  final TextEditingController _mobileController = TextEditingController();
  final FocusNode _mobileFocusNode = FocusNode();
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeIn));
    _slideController.forward();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _mobileFocusNode.dispose();
    _slideController.dispose();
    super.dispose();
  }

  bool get _isMobileValid => _mobileController.text.trim().length == 10;

  Future<void> _sendOtp() async {
    if (!_isMobileValid) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isLoading = false);

    final mobileNumber = _mobileController.text.trim();
    context.goNamed('otp', extra: mobileNumber);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildTopDecoration(size),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 48),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: ResponsiveAuthWrapper(child: _buildCard()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'terms_policy'.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.hint11.copyWith(height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopDecoration(Size size) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: size.height * 0.30,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(48),
            bottomRight: Radius.circular(48),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                AppImages.appLogo,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    'H360',
                    style: AppTextStyle.primary16bold.copyWith(
                      fontFamily: AppFonts.georgia,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          'app_name'.tr(),
          style: AppTextStyle.white20bold.copyWith(
            fontFamily: AppFonts.georgia,
            fontSize: 22,
            letterSpacing: 0.4,
          ),
        ),

        const SizedBox(height: 4),

        Text('tagline'.tr(), style: AppTextStyle.white12italic),
        SizedBox(height: 12,)
      ],

    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: _buildMobileSection(),
      ),
    );
  }

  Widget _buildMobileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('welcome'.tr(), style: AppTextStyle.displayMedium),

        const SizedBox(height: 6),

        Text('enter_mobile_desc'.tr(), style: AppTextStyle.grey13),

        const SizedBox(height: 28),

        Text('mobile_number'.tr(), style: AppTextStyle.label12),

        const SizedBox(height: 10),

        _buildMobileInput(),

        const SizedBox(height: 28),

        PrimaryButton(
          label: 'send_otp'.tr(),
          onTap: _isMobileValid ? _sendOtp : null,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildMobileInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: AppColors.inputBorder, width: 1.2),
              ),
            ),
            child: Row(
              children: [
                const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text('+91', style: AppTextStyle.black16semibold),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _mobileController,
              focusNode: _mobileFocusNode,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: AppTextStyle.black16semibold.copyWith(letterSpacing: 1.5),
              decoration: InputDecoration(
                hintText: '9876543210',
                hintStyle: AppTextStyle.hint13.copyWith(
                  fontSize: 15,
                  letterSpacing: 1,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _sendOtp(),
            ),
          ),
          if (_isMobileValid)
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 22,
              ),
            ),
        ],
      ),
    );
  }
}
