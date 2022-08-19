import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'appcolors.dart';

const String fontFamilyName = 'Quicksand';
DateFormat hrMinDF = DateFormat('HH:mm');

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.PRIMARY_COLOR,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: fontFamilyName,
      buttonTheme: ButtonThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: AppColors.ACCENT_COLOR,
      ),
    );
  }
}
