import 'package:flutter/material.dart';

import '../generated/fonts.gen.dart';
import '../index.dart';

extension ColorExtension on TextStyle {
  // Color
  TextStyle get black => copyWith(color: AppColors.black);
  TextStyle get white => copyWith(color: AppColors.white);
  TextStyle get red => copyWith(color: AppColors.red);

  // FontStyle
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  // Decoration
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  // FontWeight
  TextStyle get w100 => copyWith(fontWeight: FontWeight.w100);
  TextStyle get w200 => copyWith(fontWeight: FontWeight.w200);
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);
  TextStyle get w900 => copyWith(fontWeight: FontWeight.w900);
}

class AppStyles {
  const AppStyles._();
  static const _fontFamily = FontFamily.sFProText;
//===================
//     DISPLAY
//===================
  static const displayHuge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    height: 44 / 32,
  );
  static const displayHugeBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 44 / 32,
  );
  static const displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    height: 40 / 28,
  );
  static const displayLargeBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 28,
    height: 40 / 28,
  );
  static const displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    height: 34 / 24,
  );
  static const displayMediumBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    height: 28 / 23,
  );
  static const displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    height: 24 / 20,
  );
  static const displaySmallBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 24 / 20,
  );

  //===================
  //       BODY - Text
  //===================
  static const textLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    height: 32 / 20,
  );
  static const textMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    height: 28 / 17,
  );

  static const textMediumBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 17,
    height: 28 / 17,
  );

  static const textSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    height: 18 / 15,
  );
  static const textSmallBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 15,
    height: 24 / 15,
  );
  static const textXSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 20 / 13,
  );
  static const textXSmallSemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 20 / 13,
  );

  static const textXSmallBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 13,
    height: 20 / 13,
  );

  static const textXXSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 12 / 10,
  );

  //===================
  //    BODY - Link
  //===================
  static const linkLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    height: 32 / 20,
  );
  static const linkMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 17,
    height: 28 / 17,
  );
  static const linkSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 15,
    height: 24 / 15,
  );
  static const linkXSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 13,
    height: 22 / 13,
  );
}