import 'package:flutter/material.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(
  double fontSize,
  String fontFamily,
  Color color,
  FontWeight fontWeight,
) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: color,
    fontWeight: fontWeight,
  );
}

// regular fontstyle
TextStyle getRegularStyle({
  fontSize = FontSize.s14,
  required Color color,
  fontWeight = FontWeightManager.normal,
}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily1,
    color,
    fontWeight,
  );
}

TextStyle getHeadingStyle({fontSize = FontSize.s28, required color}) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: fontSize,
    color: color,
    fontFamily: FontConstants.fontFamily2,

  );
}

TextStyle getHeadingStyle2({fontSize = FontSize.s30, required color}) {
  return TextStyle(
    fontWeight: FontWeightManager.extraBold,
    fontSize: fontSize,
    color: color,
  );
}

// light fontstyle
TextStyle getLightStyle({
  fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily1,
    color,
    FontWeightManager.light,
  );
}

// bold fontstyle
TextStyle getBoldStyle({
  fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily1,
    color,
    FontWeightManager.bold,
  );
}

// medium fontstyle
TextStyle getMediumStyle({
  fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily1,
    color,
    FontWeightManager.medium,
  );
}
