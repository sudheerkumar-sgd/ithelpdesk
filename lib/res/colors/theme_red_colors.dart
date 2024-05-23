import 'package:flutter/material.dart';

import 'base_clors.dart';

class ThemeRedColors extends BaseColors {
  final Map<int, Color> _primary = const {
    50: Color.fromRGBO(193, 33, 63, 0.1),
    100: Color.fromRGBO(193, 33, 63, 0.2),
    200: Color.fromRGBO(193, 33, 63, 0.3),
    300: Color.fromRGBO(193, 33, 63, 0.4),
    400: Color.fromRGBO(193, 33, 63, 0.5),
    500: Color.fromRGBO(193, 33, 63, 0.6),
    600: Color.fromRGBO(193, 33, 63, 0.7),
    700: Color.fromRGBO(193, 33, 63, 0.8),
    800: Color.fromRGBO(193, 33, 63, 0.9),
    900: Color.fromRGBO(193, 33, 63, 1.0),
  };

  @override
  MaterialColor get colorAccent => Colors.amber;

  @override
  MaterialColor get colorPrimary => MaterialColor(0xff1686ce, _primary);

  @override
  Color get colorPrimaryText => const Color(0xffC1213F);

  @override
  Color get colorSecondaryText => const Color(0xffEC294E);

  @override
  Color get colorWhite => const Color(0xffffffff);

  @override
  Color get colorBlack => const Color(0xff000000);

  @override
  Color get castChipColor => Colors.deepOrangeAccent;

  @override
  Color get catChipColor => Colors.indigoAccent;

  @override
  Color get bgColor => Colors.white;

  @override
  Color get bgGradientEnd => const Color(0xFFC1213F);

  @override
  Color get bgGradientStart => const Color(0xFFEC294E);

  @override
  Color get textColor => const Color(0xFF2B2C34);

  @override
  Color get textColorLight => const Color(0xFF979797);

  @override
  Color get viewBgColor => const Color(0xFFDD143A);

  @override
  Color get viewBgColorLight => const Color(0xFFEC294E);

  @override
  Color get colorEDECEC => const Color(0xffEDECEC);

  @override
  Color get bottomSheetIconSelected => viewBgColor;

  @override
  Color get bottomSheetIconUnSelected => const Color(0xff9E9E9E);

  @override
  Color get appScaffoldBg => colorWhite;

  @override
  Color get colorF5C3C3 => const Color(0xffF5C3C3);

  @override
  Color get textColor212B4B => const Color(0xff212B4B);

  @override
  Color get colorD6D6D6 => const Color(0xffD6D6D6);

  @override
  Color get colorD32030 => const Color(0xffD32030);

  @override
  Color get colorGreen26B757 => const Color(0xff26B757);

  @override
  Color get colorBlue356DCE => const Color(0xff356DCE);

  @override
  Color get colorOrangeEB920C => const Color(0xffEB920C);

  @override
  Color get colorLightBg => const Color(0xffF8F4F4);

  @override
  Color get colorGray9E9E9E => const Color(0XFF9E9E9E);

  @override
  Color get dividerColorB3B8BF => const Color(0XFFB3B8BF).withOpacity(0.2);

  @override
  Color get iconTintColor => viewBgColorLight;

  @override
  Color get appScaffoldBg2 => const Color(0xffF5F5F5);

  @override
  Color get textFieldFillColor => const Color(0xffF7F6F6);

  @override
  Color get iconBgColorLight => const Color(0xff9E9E9E).withOpacity(0.15);
}
