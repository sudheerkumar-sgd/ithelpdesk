import 'package:flutter/material.dart';

import 'base_clors.dart';

class ThemeBlueColors extends BaseColors {
  final Map<int, Color> _primary = const {
    50: Color(0xffe8f0fc),
    100: Color(0xffd1e0fa),
    200: Color(0xffa3c1f5),
    300: Color(0xff75a2f0),
    400: Color(0xff4784eb),
    500: Color(0xff1965e6),
    600: Color(0xff1451b8),
    700: Color(0xff0f3c8a),
    800: Color(0xff0a285c),
    900: Color(0xff05142e)
  };

  @override
  MaterialColor get colorAccent => Colors.amber;

  @override
  MaterialColor get colorPrimary => MaterialColor(0xff1686ce, _primary);

  @override
  Color get colorPrimaryText => const Color(0xff175CD3);

  @override
  Color get colorSecondaryText => const Color(0xff0E4CB7);

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
  Color get bgGradientEnd => const Color(0xFF0E4CB7);

  @override
  Color get bgGradientStart => const Color(0xFF175CD3);

  @override
  Color get textColor => const Color(0xFF323C47);

  @override
  Color get textColorLight => const Color(0xFFA9B9C6);

  @override
  Color get viewBgColor => const Color(0xff446FF2);

  @override
  Color get viewBgColorLight => const Color(0xff7FB1FF);

  @override
  Color get colorEDECEC => const Color(0xffEDECEC);

  @override
  Color get bottomSheetIconSelected => viewBgColor;

  @override
  Color get bottomSheetIconUnSelected => const Color(0xff9E9E9E);

  @override
  Color get appScaffoldBg => const Color(0xFFF7F8F9);

  @override
  Color get colorF5C3C3 => const Color(0xFFD0E4F6);

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
  Color get colorLightBg => const Color.fromARGB(255, 235, 242, 248);

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

  @override
  Color get sideBarItemSelected => const Color(0xff446FF2);

  @override
  Color get sideBarItemUnselected => const Color(0xffD1DAE2);
}
