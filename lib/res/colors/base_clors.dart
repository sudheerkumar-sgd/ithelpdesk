import 'package:flutter/material.dart';

abstract class BaseColors {
  //theme color
  MaterialColor get colorPrimary;

  MaterialColor get colorAccent;

  //text color
  Color get colorPrimaryText;

  Color get colorSecondaryText;

  //chips color
  Color get catChipColor;

  Color get castChipColor;

  //extra color
  Color get colorWhite;

  Color get colorBlack;

  Color get bgColor;

  Color get textColor;

  Color get textColorLight;

  Color get viewBgColor;

  Color get viewBgColorLight;

  Color get bgGradientStart;

  Color get bgGradientEnd;

  Color get colorEDECEC;

  Color get bottomSheetIconSelected;

  Color get bottomSheetIconUnSelected;

  Color get appScaffoldBg;

  Color get colorF5C3C3;

  Color get textColor212B4B;

  Color get colorD6D6D6;

  Color get colorD32030;

  Color get colorGreen26B757;

  Color get colorBlue356DCE;

  Color get colorOrangeEB920C;

  Color get colorLightBg;

  Color get colorGray9E9E9E;

  Color get dividerColorB3B8BF;

  Color get iconTintColor;

  Color get appScaffoldBg2;

  Color get textFieldFillColor;

  Color get iconBgColorLight;

  Color get completed => const Color(0xFF3ECA6E);

  Color get rejected => const Color(0xFFFF0000);

  Color get pending => const Color(0xFFFF8832);
}
