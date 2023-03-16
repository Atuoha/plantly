import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/color.dart';
import 'styles_manager.dart';
import 'values_manager.dart';
import 'font_manager.dart';

// Light Dark Theme
ThemeData getLightTheme() {
  return ThemeData(
    primaryColor: primaryColor,
    primaryColorLight: Colors.black,
    primaryColorDark: Colors.white,
    backgroundColor: whiteColor,
    scaffoldBackgroundColor: whiteColor,

    // dialog theme
    dialogTheme: const DialogTheme(
      backgroundColor: whiteColor,
      titleTextStyle: TextStyle(
        color: Colors.black,
      ),
      contentTextStyle: TextStyle(
        color: Colors.black,
      ),
    ),

    // Bottom sheet theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: whiteColor,
    ),



    // card theme
    cardTheme: CardTheme(
      color: whiteColor,
      shadowColor: Colors.grey,
      elevation: AppSize.s4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
    ),

    // button theme
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      shape: StadiumBorder(),
      disabledColor: whiteColor,
    ),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s25),
        ),
        padding: const EdgeInsets.symmetric(vertical:AppSize.s16),
        backgroundColor: accentColor,
        disabledBackgroundColor: accentColor,
        disabledForegroundColor: Colors.white,
        textStyle: getRegularStyle(
          color: Colors.white,
          fontSize: FontSize.s16,
          fontWeight: FontWeightManager.bold,
        ),
      ),
    ),

    // input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      fillColor: whiteColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s8),
        borderSide:  const BorderSide(color: liteGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s8),
        borderSide:  const BorderSide(color: accentColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s8),
        borderSide: const BorderSide(color: accentColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s8),
        borderSide: const BorderSide(color: accentColor, width:2),
      ),
      labelStyle: getRegularStyle(color: Colors.black),
      hintStyle: getRegularStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.all(AppPadding.p8),
      errorStyle: getRegularStyle(color: Colors.red),
      suffixIconColor: accentColor,
      suffixStyle: getRegularStyle(color: Colors.grey),
      prefixIconColor: accentColor,
      prefixStyle: getRegularStyle(color: Colors.grey),
    ),

    // app bar theme
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(
        color: Colors.black,
        size: AppSize.s40,
      ),
      color: Colors.transparent,
      elevation: AppSize.s0,
      titleTextStyle: getRegularStyle(
        color: Colors.black,
        // fontSize: FontSize.s16,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    // text theme
    textTheme: TextTheme(
      headline1: getMediumStyle(
        color: Colors.black,
        fontSize: FontSize.s16,
      ),
      caption: getRegularStyle(
        color: Colors.black,
        fontSize: FontSize.s12,
      ),
      bodyText1: getRegularStyle(
        color: Colors.black,
      ),
    ),

    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.grey,
    ),
  );
}
