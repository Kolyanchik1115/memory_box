import 'package:flutter/material.dart';

import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';

class AppThemes {
  const AppThemes._();

  static ThemeData light() {
    return ThemeData(
      fontFamily: AppFonts.fontFamily,
      scaffoldBackgroundColor: AppColors.white,
    );
  }
}
