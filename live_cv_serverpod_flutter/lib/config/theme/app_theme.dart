import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';

///Theme class responsible for storing theme variables to be used throughout the app.
class AppTheme {
  static final ThemeData currentTheme = Managers.theme.themeMode == ThemeMode.light ? lightTheme : darkTheme;

  //dark theme data
  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      secondary: Colors.transparent, //android overscroll glow color
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    //colors
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: const Color(0xff111111),
    primaryColorLight: const Color.fromRGBO(71, 102, 152, 1.0),
    primaryColorDark: const Color.fromRGBO(155, 193, 240, 1.0),
    primaryColor: const Color.fromRGBO(3, 63, 120, 1.0),
    cupertinoOverrideTheme: //update cupertino theme data override if changing this
        const CupertinoThemeData(primaryColor: Color.fromRGBO(3, 63, 120, 1.0)),
    disabledColor: const Color(0xffd1d1d1),
    dividerColor: const Color(0xff1f1f1f),
    secondaryHeaderColor: const Color(0xffaaaaaa),
    hintColor: const Color(0xff606060),

    //appBar
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xff111111),
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // For Android (light icons)
        statusBarBrightness: Brightness.dark, // For iOS (light icons)
      ),
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 16,
        color: const Color(0xffffffff),
        fontWeight: FontWeight.w600,
      ),
    ),
    //text
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: Colors.black.withOpacity(0.1),
      selectionHandleColor: Colors.black,
    ),
    textTheme: GoogleFonts.robotoTextTheme(_getTextTheme(const Color(0xffeeeeee))),
  );

  //light theme data
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      secondary: Colors.transparent, //android overscroll glow color
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    //colors
    scaffoldBackgroundColor: const Color(0xfff5f5f5),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    primaryColorDark: const Color.fromRGBO(71, 102, 152, 1.0),
    primaryColorLight: const Color.fromRGBO(155, 193, 240, 1.0),

    primaryColor: const Color.fromRGBO(3, 63, 120, 1.0),
    cupertinoOverrideTheme: //update cupertino theme data override if changing this
        const CupertinoThemeData(primaryColor: Color.fromRGBO(3, 63, 120, 1.0)),

    disabledColor: const Color(0xffc1c1c1),
    dividerColor: const Color(0xffe1e1e1),

    secondaryHeaderColor: const Color(0xff606060),
    hintColor: const Color(0xffaaaaaa),

    //appBar
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xfff5f5f5),
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 16,
        color: const Color(0xff111111),
        fontWeight: FontWeight.w600,
      ),
    ),
    //text
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: Colors.black.withOpacity(0.1),
      selectionHandleColor: Colors.black,
    ),
    textTheme: GoogleFonts.robotoTextTheme(_getTextTheme(const Color(0xff111111))),
  );

  static TextTheme _getTextTheme(Color color) {
    return TextTheme(
      //titles and headings
      titleLarge: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w600),
      //thicker body
      displayLarge: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.w500),
      displayMedium: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w500),
      displaySmall: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500),
      //body primary
      bodyLarge: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w400),
    );
  }
}
