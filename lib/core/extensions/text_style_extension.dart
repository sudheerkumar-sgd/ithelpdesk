import 'package:flutter/material.dart';
import 'package:smartuaq/core/extensions/build_context_extension.dart';

extension TextStyleHelper on BuildContext {
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;
  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium;
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;
  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;
  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;

  //Custom styles
  TextStyle get textFontWeight300 => TextStyle(
        color: resources.color.textColor,
        fontSize: resources.fontSize.dp14,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
      );
  TextStyle get textFontWeight400 => TextStyle(
        color: resources.color.textColor,
        fontSize: resources.fontSize.dp14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      );
  TextStyle get textFontWeight500 => TextStyle(
        color: resources.color.textColor,
        fontSize: resources.fontSize.dp14,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      );
  TextStyle get textFontWeight600 => TextStyle(
        color: resources.color.textColor,
        fontSize: resources.fontSize.dp14,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
      );
  TextStyle get textFontWeight700 => TextStyle(
        color: resources.color.textColor,
        fontSize: resources.fontSize.dp14,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      );
  TextStyle get textFontWeight800 => TextStyle(
        color: resources.color.textColor,
        fontSize: resources.fontSize.dp14,
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.normal,
      );
  TextStyle get textFontWeight900 => TextStyle(
        color: resources.color.textColor,
        fontSize: resources.fontSize.dp14,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.normal,
      );
}

extension TextStyleColorMapping on TextStyle {
  TextStyle onPrimary(BuildContext context) {
    return copyWith(color: Theme.of(context).colorScheme.onPrimary);
  }

  TextStyle onSecondary(BuildContext context) {
    return copyWith(color: Theme.of(context).colorScheme.onSecondary);
  }

  TextStyle onTertiary(BuildContext context) {
    return copyWith(color: Theme.of(context).colorScheme.onTertiary);
  }

  TextStyle onPrimaryContainer(BuildContext context) {
    return copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer);
  }

  TextStyle onSecondaryContainer(BuildContext context) {
    return copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer);
  }

  TextStyle onTertiaryContainer(BuildContext context) {
    return copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer);
  }

  TextStyle onSurface(BuildContext context) {
    return copyWith(color: Theme.of(context).colorScheme.onSurface);
  }

  //custom colors
  TextStyle onColor(Color color) {
    return copyWith(color: color);
  }
}

extension TextStyleFontSizeMapping on TextStyle {
  //custom font Sizes
  TextStyle onFontSize(double size) {
    return copyWith(fontSize: size);
  }
}

extension TextStyleFontFamilyMapping on TextStyle {
  //custom font Sizes
  TextStyle onFontFamily({required String fontFamily}) {
    return copyWith(fontFamily: fontFamily);
  }
}

extension TextStyleHeightMapping on TextStyle {
  //custom font Sizes
  TextStyle onHeight(double height) {
    return copyWith(height: height);
  }
}
