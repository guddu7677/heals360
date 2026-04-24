import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hells360/core/constant/app_textstyle.dart';
import 'package:hells360/core/constant/app_theme.dart';


class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen>
    with TickerProviderStateMixin {
  bool _otpSent = false;
  bool _isLoading = false;
  String _mobileNumber = '';
  final int _otpLength = 6;
  int _resendCooldown = 0;
  Timer? _resendTimer;
  final TextEditingController _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
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
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocusNodes) f.dispose();
    _mobileFocusNode.dispose();
    _resendTimer?.cancel();
    _slideController.dispose();
    super.dispose();
  }

  bool get _isMobileValid => _mobileController.text.trim().length == 10;
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

  Future<void> _sendOtp() async {
    if (!_isMobileValid) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() {
      _isLoading = false;
      _mobileNumber = _mobileController.text.trim();
      _otpSent = true;
    });
    _startResendTimer();
    _slideController
      ..reset()
      ..forward();

    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) _otpFocusNodes[0].requestFocus();
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() => _isLoading = false);

    
    _showSuccessSnackbar();
  }

  void _resendOtp() {
    if (_resendCooldown > 0) return;
    for (final c in _otpControllers) c.clear();
    _sendOtp();
  }

  void _changeMobile() {
    setState(() {
      _otpSent = false;
      for (final c in _otpControllers) c.clear();
    });
    _slideController
      ..reset()
      ..forward();
    _resendTimer?.cancel();
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _mobileFocusNode.requestFocus(),
    );
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
            Text('Logged in successfully!', style: AppTextStyle.white14),
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
                        child: _buildCard(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'By continuing, you agree to our Terms of Service\n& Privacy Policy',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.hint11.copyWith(height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
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

        const SizedBox(height: 12),

        Text(
          'Heal360 Wellness',
          style: AppTextStyle.white20bold.copyWith(
            fontFamily: AppFonts.georgia,
            fontSize: 22,
            letterSpacing: 0.4,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          'Where Hope Begins & Fertility is Reclaimed',
          style: AppTextStyle.white12italic,
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
        child: _otpSent ? _buildOtpSection() : _buildMobileSection(),
      ),
    );
  }

  Widget _buildMobileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome', style: AppTextStyle.displayMedium),

        const SizedBox(height: 6),

        Text(
          'Enter your mobile number to login or create\nan account automatically.',
          style: AppTextStyle.grey13,
        ),

        const SizedBox(height: 28),

        Text('Mobile Number', style: AppTextStyle.label12),

        const SizedBox(height: 10),

        _buildMobileInput(),

        const SizedBox(height: 28),

        _buildPrimaryButton(
          label: 'Send OTP',
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

  Widget _buildOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Verify OTP', style: AppTextStyle.displayMedium),

        const SizedBox(height: 6),

        RichText(
          text: TextSpan(
            style: AppTextStyle.grey13,
            children: [
              const TextSpan(text: 'We sent a 6-digit OTP to\n'),
              TextSpan(
                text: '+91 $_mobileNumber',
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
                'Change Number',
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
                    ? 'Resend in ${_resendCooldown}s'
                    : 'Resend OTP',
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

        _buildPrimaryButton(
          label: 'Verify & Continue',
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

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    final bool enabled = onTap != null && !isLoading;

    return GestureDetector(
      onTap: enabled ? onTap : null,
//       (){
//         Navigator.of(context).pushReplacement(
//   MaterialPageRoute(builder: (_) => const MainScreen()),
// );
//       },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: enabled
              ? AppColors.primaryGradientHorizontal
              : const LinearGradient(
                  colors: [Color(0xFFCCB0B9), Color(0xFFCCB0B9)],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(label, style: AppTextStyle.white16bold),
        ),
      ),
    );
  }
}
