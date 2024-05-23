import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeBlue extends ApplicationTheme {
  static ThemeBlue? _instance;
  static ThemeBlue get instance {
    _instance ??= ThemeBlue._init();
    return _instance!;
  }

  String? _fontFamily;
  @override
  fontFamily(String fontFamily) {
    _fontFamily = fontFamily;
  }

  ThemeBlue._init();

  @override
  @override
  ThemeData? get theme => ThemeData(
        primarySwatch: const MaterialColor(4288120051, {
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
        }),
        useMaterial3: false,
        brightness: Brightness.light,
        primaryColor: const Color(0xff175cd2),
        primaryColorLight: const Color(0xffd1e0fa),
        primaryColorDark: const Color(0xff0f3c8a),
        canvasColor: const Color(0xfffafafa),
        scaffoldBackgroundColor: const Color(0xfffafafa),
        cardColor: const Color(0xffffffff),
        dividerColor: const Color(0x1f000000),
        highlightColor: const Color(0x00000000),
        splashColor: const Color(0x00000000),
        unselectedWidgetColor: const Color(0x8a000000),
        disabledColor: const Color(0x61000000),
        secondaryHeaderColor: const Color(0xffe8f0fc),
        dialogBackgroundColor: const Color(0xffffffff),
        indicatorColor: const Color(0xff175cd2),
        hintColor: const Color(0x8a000000),
        fontFamily: _fontFamily ?? 'Inter',
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Color(0xff175cd2)),
        datePickerTheme:
            const DatePickerThemeData(headerBackgroundColor: Color(0xff175cd2)),
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          radius: const Radius.circular(10.0),
          thumbColor: MaterialStateProperty.all(const Color(0xff175CD3)),
        ),
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
          minWidth: 88,
          height: 36,
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff000000),
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
          alignedDropdown: false,
          buttonColor: Color(0xffe0e0e0),
          disabledColor: Color(0x61000000),
          highlightColor: Color(0x29000000),
          splashColor: Color(0x1f000000),
          focusColor: Color(0x1f000000),
          hoverColor: Color(0x0a000000),
          colorScheme: ColorScheme(
            primary: Color(0xff175cd2),
            secondary: Color(0xff1965e6),
            surface: Color(0xffffffff),
            background: Color(0xffa3c1f5),
            error: Color(0xffd32f2f),
            onPrimary: Color(0xffffffff),
            onSecondary: Color(0xffffffff),
            onSurface: Color(0xff000000),
            onBackground: Color(0xffffffff),
            onError: Color(0xffffffff),
            brightness: Brightness.light,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0x8a000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          displayMedium: TextStyle(
            color: Color(0x8a000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          displaySmall: TextStyle(
            color: Color(0x8a000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          headlineMedium: TextStyle(
            color: Color(0x8a000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          headlineSmall: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          titleLarge: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          titleMedium: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          bodyLarge: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          bodyMedium: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          bodySmall: TextStyle(
            color: Color(0x8a233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          labelLarge: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          titleSmall: TextStyle(
            color: Color(0xff233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          labelSmall: TextStyle(
            color: Color(0xff233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
      );
}
