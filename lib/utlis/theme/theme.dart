import 'package:ecommerce_app/utlis/theme/widgets_theme/appbar_them.dart';
import 'package:ecommerce_app/utlis/theme/widgets_theme/bottom_sheet_theme.dart';
import 'package:ecommerce_app/utlis/theme/widgets_theme/checkbox_theme.dart';
import 'package:ecommerce_app/utlis/theme/widgets_theme/chip_theme.dart';
import 'package:ecommerce_app/utlis/theme/widgets_theme/elevated_button_theme.dart';
import 'package:ecommerce_app/utlis/theme/widgets_theme/outlined_button_theme.dart';
import 'package:ecommerce_app/utlis/theme/widgets_theme/text_field_theme.dart';
import 'package:ecommerce_app/utlis/theme/widgets_theme/text_theme.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class UAppTheme {
  UAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: UColors.grey,
    brightness: Brightness.light,
    primaryColor: UColors.primary,
    textTheme: HkTextTheme.lightTextTheme,
    chipTheme: UChipTheme.lightChipTheme,
    scaffoldBackgroundColor: UColors.white,
    appBarTheme: HkAppBarTheme.lightAppBarTheme,
    checkboxTheme: HkCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: HkBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: HkElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: HkOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: HkTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: UColors.grey,
    brightness: Brightness.dark,
    primaryColor: UColors.primary,
    textTheme: HkTextTheme.darkTextTheme,
    chipTheme: UChipTheme.darkChipTheme,
    scaffoldBackgroundColor: UColors.black,
    appBarTheme: HkAppBarTheme.darkAppBarTheme,
    checkboxTheme: HkCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: HkBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: HkElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: HkOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: HkTextFormFieldTheme.darkInputDecorationTheme,
  );
}
