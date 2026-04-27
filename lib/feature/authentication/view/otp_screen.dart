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

class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpScreen({super.key, required this.mobileNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  bool _isLoading = false;
  final int _otpLength = 6;
  int _resendCooldown = 30;
  Timer? _resendTimer;

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  String? _selectedLanguage;
  final Map<String, Locale> _languages = {
    'English': const Locale('en'),
    'हिंदी (Hindi)': const Locale('hi'),
    'বাংলা (Bengali)': const Locale('bn'),
    'తెలుగు (Telugu)': const Locale('te'),
    'मराठी (Marathi)': const Locale('mr'),
    'தமிழ் (Tamil)': const Locale('ta'),
    'اردو (Urdu)': const Locale('ur'),
    'ગુજરાતી (Gujarati)': const Locale('gu'),
    'ಕನ್ನಡ (Kannada)': const Locale('kn'),
    'ଓଡ଼ିଆ (Odia)': const Locale('or'),
    'മലയാളം (Malayalam)': const Locale('ml'),
    'ਪੰਜਾਬੀ (Punjabi)': const Locale('pa'),
  };

  @override
  void initState() {
    super.initState();
    _startResendTimer();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _otpFocusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocusNodes) f.dispose();
    _resendTimer?.cancel();
    _slideController.dispose();
    super.dispose();
  }

  String get _otpValue => _otpControllers.map((c) => c.text).join();
  bool get _isOtpComplete => _otpValue.length == _otpLength;

  void _startResendTimer() {
    _resendCooldown = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendCooldown == 0) {
        t.cancel();
      } else {
        setState(() => _resendCooldown--);
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    // Simulate API verification
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isLoading = false);

    _showSuccessSnackbar();
    context.goNamed('home');
  }

  void _resendOtp() {
    if (_resendCooldown > 0) return;
    for (final c in _otpControllers) c.clear();
    setState(() {});
    _startResendTimer();
    _otpFocusNodes[0].requestFocus();
  }

  void _changeMobile() {
    context.goNamed('login');
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text('login_success'.tr(), style: AppTextStyle.white14),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
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
                    const SizedBox(height: 20),
                    _buildLanguageSelector(),
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 30),
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

  Widget _buildLanguageSelector() {
    // Find the name of the currently active locale
    String currentLangName = _languages.entries
        .firstWhere(
          (entry) => entry.value == context.locale,
          orElse: () => const MapEntry('English', Locale('en')),
        )
        .key;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentLangName,
          icon: const Icon(Icons.language, color: AppColors.primary),
          style: AppTextStyle.primary14semibold,
          hint: Text(
            'select_language'.tr(),
            style: AppTextStyle.primary14semibold,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              context.setLocale(_languages[newValue]!);
            }
          },
          items: _languages.keys.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: AppTextStyle.black14semibold),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTopDecoration(Size size) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: size.height * 0.35,
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

        const SizedBox(height: 12),

        Text(
          'app_name'.tr(),
          style: AppTextStyle.white20bold.copyWith(
            fontFamily: AppFonts.georgia,
            fontSize: 22,
            letterSpacing: 0.4,
          ),
        ),
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
        child: _buildOtpSection(),
      ),
    );
  }

  Widget _buildOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('verify_otp'.tr(), style: AppTextStyle.displayMedium),

        const SizedBox(height: 6),

        RichText(
          text: TextSpan(
            style: AppTextStyle.grey13,
            children: [
              TextSpan(text: 'otp_sent_to'.tr()),
              TextSpan(
                text: '+91 ${widget.mobileNumber}',
                style: AppTextStyle.primary14semibold.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        _buildOtpBoxes(),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _changeMobile,
              child: Text(
                'change_number'.tr(),
                style: AppTextStyle.primary13semibold.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),

            GestureDetector(
              onTap: _resendCooldown == 0 ? _resendOtp : null,
              child: Text(
                _resendCooldown > 0
                    ? 'resend_in'.tr(args: [_resendCooldown.toString()])
                    : 'resend_otp'.tr(),
                style:
                    (_resendCooldown > 0
                            ? AppTextStyle.hint13
                            : AppTextStyle.primary13semibold)
                        .copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: _resendCooldown == 0
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          decorationColor: AppColors.primary,
                        ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        PrimaryButton(
          label: 'verify_and_continue'.tr(),
          onTap: _isOtpComplete ? _verifyOtp : null,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_otpLength, _buildOtpBox),
    );
  }

  Widget _buildOtpBox(int index) {
    final bool hasFocus = _otpFocusNodes[index].hasFocus;
    final bool filled = _otpControllers[index].text.isNotEmpty;

    return SizedBox(
      width: 40,
      height: 52,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: filled ? AppColors.otpBoxFill : AppColors.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasFocus
                ? AppColors.otpBoxActive
                : filled
                ? AppColors.otpBoxBorder
                : AppColors.inputBorder,
            width: hasFocus ? 2.0 : 1.2,
          ),
          boxShadow: hasFocus
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: TextField(
          controller: _otpControllers[index],
          focusNode: _otpFocusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyle.primary16bold.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            setState(() {});
            if (value.isNotEmpty && index < _otpLength - 1) {
              _otpFocusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _otpFocusNodes[index - 1].requestFocus();
            }
            if (_isOtpComplete) FocusScope.of(context).unfocus();
          },
          onTap: () => setState(() {}),
        ),
      ),
    );
  }
}
