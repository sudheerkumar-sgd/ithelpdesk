import 'package:flutter/material.dart';

import 'app_theme.dart';

class ThemePeach extends ApplicationTheme {
  static ThemePeach? _instance;

  static ThemePeach get instance {
    _instance ??= ThemePeach._init();
    return _instance!;
  }

  String? _fontFamily;
  @override
  fontFamily(String fontFamily) {
    _fontFamily = fontFamily;
  }

  ThemePeach._init();

  @override
  ThemeData? get theme => ThemeData(
        primarySwatch: const MaterialColor(4287047461, {
          50: Color.fromRGBO(135, 39, 38, 0.1),
          100: Color.fromRGBO(135, 39, 38, 0.2),
          200: Color.fromRGBO(135, 39, 38, 0.3),
          300: Color.fromRGBO(135, 39, 38, 0.4),
          400: Color.fromRGBO(135, 39, 38, 0.5),
          500: Color.fromRGBO(135, 39, 38, 0.6),
          600: Color.fromRGBO(135, 39, 38, 0.7),
          700: Color.fromRGBO(135, 39, 38, 0.8),
          800: Color.fromRGBO(135, 39, 38, 0.9),
          900: Color.fromRGBO(135, 39, 38, 1.0),
        }),
        useMaterial3: false,
        brightness: Brightness.light,
        primaryColor: const Color(0xff872725),
        primaryColorLight: const Color(0xfff4d8d7),
        primaryColorDark: const Color(0xff782321),
        canvasColor: const Color(0xfffafafa),
        scaffoldBackgroundColor: const Color(0xfffafafa),
        cardColor: const Color(0xffffffff),
        dividerColor: const Color(0x1f000000),
        highlightColor: const Color(0x00000000),
        splashColor: const Color(0x00000000),
        unselectedWidgetColor: const Color(0x8a000000),
        disabledColor: const Color(0x61000000),
        secondaryHeaderColor: const Color(0xfffaebeb),
        dialogBackgroundColor: const Color(0xffffffff),
        indicatorColor: const Color(0xff872725),
        hintColor: const Color(0x8a000000),
        fontFamily: _fontFamily ?? 'Inter',
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Color(0xff872725)),
        datePickerTheme:
            const DatePickerThemeData(headerBackgroundColor: Color(0xff872725)),
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          radius: const Radius.circular(10.0),
          thumbColor: MaterialStateProperty.all(const Color(0xff872725)),
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
          highlightColor: Color(0x00000000),
          splashColor: Color(0x1f000000),
          focusColor: Color(0x1f000000),
          hoverColor: Color(0x0a000000),
          colorScheme: ColorScheme(
            primary: Color(0xff872725),
            secondary: Color(0xffc83a37),
            surface: Color(0xffffffff),
            background: Color(0xffe9b0af),
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
