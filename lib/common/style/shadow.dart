import 'package:ecommerce_app/utlis/constants/colors.dart';
import 'package:flutter/material.dart';

class UShadow {
  UShadow._();
  static List<BoxShadow> searchBarShadow = [
    BoxShadow(
      color: UColors.black.withValues(alpha: 0.1),
      blurRadius: 2.0,
      spreadRadius: 4.0,
    ),
  ];
  static List<BoxShadow> verticalProductShadow = [
    BoxShadow(
      color: UColors.darkGrey.withValues(alpha: 0.1),
      blurRadius: 50.0,
      spreadRadius: 7.0,
      offset: const Offset(0, 2),
    ),
  ];
}
