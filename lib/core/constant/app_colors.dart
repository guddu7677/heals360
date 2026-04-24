import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF7A1E3A); 

  static const Color gradientTop = Color(0xFF8E2448);
  static const Color gradientBottom = Color(0xFFB23A5B);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gradientTop, gradientBottom],
  );

  static const LinearGradient primaryGradientHorizontal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientTop, gradientBottom],
  );

  static const Color background = Color(0xFFF8F8F8);     
  static const Color surface = Color(0xFFFFFFFF);        
  static const Color surfaceVariant = Color(0xFFF2EDF0);  

  static const Color textPrimary = Color(0xFF1A1A1A);     
  static const Color textSecondary = Color(0xFF6B6B6B);  
  static const Color textHint = Color(0xFFAAAAAA);       
  static const Color textOnPrimary = Color(0xFFFFFFFF);  

  static const Color accent = Color(0xFF7A1E3A);         
  static const Color divider = Color(0xFFE0D6DA);        
  static const Color inputBorder = Color(0xFFD4C5CB);   
  static const Color inputFocusBorder = Color(0xFF7A1E3A);
  static const Color inputFill = Color(0xFFFDF9FB);       

  static const Color success = Color(0xFF2D7A4F);
  static const Color error = Color(0xFFB00020);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF1E6A8A);

  static const Color overlay = Color(0x557A1E3A);        
  static const Color shadow = Color(0x1A7A1E3A);         

  static const Color otpBoxBorder = Color(0xFF8E2448);
  static const Color otpBoxFill = Color(0xFFFDF4F7);
  static const Color otpBoxActive = Color(0xFF7A1E3A);
}