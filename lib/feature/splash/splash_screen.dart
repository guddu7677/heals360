import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hells360/core/constant/app_textstyle.dart';
import 'package:hells360/core/constant/app_theme.dart';
import 'package:hells360/feature/authentication/view/login_register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _taglineController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor          : Colors.transparent,
      statusBarIconBrightness : Brightness.light,
    ));
    _logoController = AnimationController(
      vsync   : this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve : const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _textController = AnimationController(
      vsync   : this,
      duration: const Duration(milliseconds: 600),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end  : Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _taglineController = AnimationController(
      vsync   : this,
      duration: const Duration(milliseconds: 500),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end  : Offset.zero,
    ).animate(CurvedAnimation(parent: _taglineController, curve: Curves.easeOut));

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 150));
    await _textController.forward();

    await Future.delayed(const Duration(milliseconds: 100));
    await _taglineController.forward();

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder        : (_, __, ___) => const LoginRegisterScreen(),
        transitionsBuilder : (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration : const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin  : Alignment.topLeft,
            end    : Alignment.bottomRight,
            colors : [Color(0xFFF8F8F8), Color(0xFFF2EDF0)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedLogo(),

                const SizedBox(height: 32),
                FadeTransition(
                  opacity : _textOpacity,
                  child   : SlideTransition(
                    position: _textSlide,
                    child   : _buildBrandName(),
                  ),
                ),

                const SizedBox(height: 10),
                FadeTransition(
                  opacity : _taglineOpacity,
                  child   : SlideTransition(
                    position: _taglineSlide,
                    child   : Text(
                      'Where Hope Begins & Fertility is Reclaimed',
                      textAlign: TextAlign.center,
                      style    : AppTextStyle.grey13.copyWith(
                        fontStyle    : FontStyle.italic,
                        letterSpacing: 0.3,
                        height       : 1.4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
                FadeTransition(
                  opacity: _taglineOpacity,
                  child  : SizedBox(
                    width : 36,
                    height: 3,
                    child : LinearProgressIndicator(
                      backgroundColor: AppColors.divider,
                      valueColor      : const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder  : (_, child) => Transform.scale(
        scale  : _logoScale.value,
        child  : Opacity(opacity: _logoOpacity.value, child: child),
      ),
      child: Container(
        width     : 160,
        height    : 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color       : Colors.white,
          boxShadow   : [
            BoxShadow(
              color      : AppColors.shadow,
              blurRadius : 30,
              spreadRadius: 2,
              offset     : const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child       : Image.asset(
            AppImages.appLogo,
            fit         : BoxFit.contain,
            errorBuilder: (_, __, ___) => _buildLogoFallback(),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandName() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text : 'Heal',
            style: AppTextStyle.displayLarge,
          ),
          TextSpan(
            text : '360 ',
            style: AppTextStyle.displayLarge.copyWith(
              color: AppColors.gradientBottom,
            ),
          ),
          TextSpan(
            text : 'Wellness',
            style: AppTextStyle.displayLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoFallback() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(
        child: Text(
          'H360',
          style: AppTextStyle.white20bold.copyWith(
            fontFamily: AppFonts.georgia,
            fontSize  : 32,
          ),
        ),
      ),
    );
  }
}