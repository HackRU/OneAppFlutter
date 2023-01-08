import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// /// Palette
// const pink_light = Color(0xFFe06969);
// const pink = Color(0xFFC85151);
// const web_link = Color(0xFF732d2d);
// const pink_dark = Color(0xFF592323);
// const green = Color(0xFF4FAB5F);
// const yellow = Color(0xFFf1ba43);
// var yellowLight = Colors.yellow.shade500;

// /// Black & White
// const white = Colors.white;
// const off_white = Color(0xFFfff5e8);
// const grey_light = Color(0xFFe1e6e8);
// const grey = Color(0xFF898c8c);
// const HackRUColors.charcoal_light = Color(0xFF4a4a4a);
// const charcoal = Color(0xFF292929);
// const charcoal_dark = Color(0xFF1A1A1A);
// const black = Colors.black;
// const semi_transparent = Colors.black87;
// const transparent = Color(0x00ffffff);
// const box_shadow = Color(0x0d000000);
// const overlay = Color.fromRGBO(0, 0, 0, 80);

// const ada_pink = Color(0xFFB94B4B);
// const ada_green = Color(0xFF3D854A);

// const g_pink_yellow = LinearGradient(
//   colors: [HackRUColors.yellow, HackRUColors.pink],
//   begin: Alignment.topCenter,
//   end: Alignment.bottomCenter,
//   stops: [0.0, 1.0],
//   tileMode: TileMode.clamp,
// );

abstract class HackRUColors {
  static const Color blue = Color(0xff1f6aa0);
  static const Color off_white_blue = Color(0xffd1e9ef);
  static const Color blue_grey = Colors.blueGrey;
  static const LinearGradient loading_gradient = LinearGradient(colors: [
    Colors.black26,
    Colors.transparent,
  ]);

  static const Color pink_light = Color(0xFFe06969);
  static const Color pink = Color(0xFFC85151);
  static const Color web_link = Color(0xFF732d2d);
  static const Color pink_dark = Color(0xFF592323);
  static const Color green = Color(0xFF4FAB5F);
  static const Color yellow = Color(0xFFf1ba43);
  static const Color yellowLight = Color.fromRGBO(255, 235, 59, 1);

  static const Color white = Colors.white;
  static const Color off_white = Color(0xFFfff5e8);
  static const Color grey_light = Color(0xFFe1e6e8);
  static const Color grey = Color(0xFF898c8c);
  static const Color charcoal_light = Color(0xFF4a4a4a);
  static const Color charcoal = Color(0xFF292929);
  static const Color charcoal_dark = Color(0xFF1A1A1A);
  static const Color black = Colors.black;
  static const Color semi_transparent = Colors.black87;
  static const Color transparent = Color(0x00ffffff);
  static const Color box_shadow = Color(0x0d000000);
  static const Color overlay = Color.fromRGBO(0, 0, 0, 80);

  static const Color ada_pink = Color(0xFFB94B4B);
  static const Color ada_green = Color(0xFF3D854A);

  static const LinearGradient g_pink_yellow = LinearGradient(
    colors: [HackRUColors.yellow, HackRUColors.pink],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
  );
}

/*
<< OLD >>  SIZE   WEIGHT    << NEW >>
display4   112.0  thin      headline1
display3   56.0   normal    headline2
display2   45.0   normal    headline3
display1   34.0   normal    headline4
headline   24.0   normal    headline5
title      20.0   medium    headline6
subhead    16.0   normal    subtitle1
subtitle   14.0   medium    subtitle2
body2      14.0   medium    bodyText1
body1      14.0   normal    bodyText2
caption    12.0   normal    caption
button     14.0   medium    button
overline   10.0   normal    overline
*/

/// Themes
final kTheme = _buildTheme();

ThemeData _buildTheme() {
  final base = ThemeData(
    brightness: Brightness.light,
    primaryColor: HackRUColors.pink,
    primaryColorLight: HackRUColors.white,
    primaryColorDark: HackRUColors.pink_dark,
    accentColor: HackRUColors.yellow,
    backgroundColor: HackRUColors.white,
    scaffoldBackgroundColor: HackRUColors.white,
    fontFamily: 'TitilliumWeb',
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade200,
      thickness: 2.0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: HackRUColors.charcoal_light, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      fillColor: HackRUColors.charcoal_light,
      labelStyle: const TextStyle(
        color: HackRUColors.charcoal_light,
      ),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 100.0,
        color: HackRUColors.off_white_blue,
        fontWeight: FontWeight.w600,
      ),
      headline2: TextStyle(
        fontSize: 90.0,
        color: HackRUColors.off_white_blue,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 45.0,
        color: HackRUColors.off_white_blue,
      ),
      headline4: TextStyle(
        fontSize: 35.0,
        color: HackRUColors.off_white_blue,
      ),
      headline5: TextStyle(
        fontSize: 25.0,
        color: HackRUColors.off_white_blue,
        fontWeight: FontWeight.w700,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        color: HackRUColors.off_white_blue,
        fontWeight: FontWeight.w700,
      ),
      subtitle1: TextStyle(
        fontSize: 18.0,
        color: HackRUColors.off_white_blue,
        fontWeight: FontWeight.w700,
      ),
      bodyText1: TextStyle(
        color: HackRUColors.off_white_blue,
      ),
      bodyText2: TextStyle(
        color: HackRUColors.off_white_blue,
      ),
    ),
    primaryTextTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 100.0,
        color: HackRUColors.off_white_blue,
        fontWeight: FontWeight.w600,
      ),
      headline2: TextStyle(
        fontSize: 90.0,
        color: HackRUColors.off_white_blue,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 45.0,
        color: HackRUColors.off_white_blue,
      ),
      headline4: TextStyle(
        fontSize: 35.0,
        color: HackRUColors.off_white_blue,
      ),
      headline5: TextStyle(
        fontSize: 25.0,
        color: HackRUColors.off_white_blue,
        fontWeight: FontWeight.w700,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        color: HackRUColors.off_white_blue,
        fontWeight: FontWeight.w700,
      ),
      subtitle1: TextStyle(
        fontSize: 18.0,
        color: HackRUColors.off_white_blue,
        fontWeight: FontWeight.w700,
      ),
      bodyText1: TextStyle(
        color: HackRUColors.off_white_blue,
      ),
      bodyText2: TextStyle(
        color: HackRUColors.off_white_blue,
      ),
    ),
    accentTextTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 100.0,
        color: HackRUColors.blue_grey,
        fontWeight: FontWeight.w600,
      ),
      headline2: TextStyle(
        fontSize: 90.0,
        color: HackRUColors.blue_grey,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 45.0,
        color: HackRUColors.blue_grey,
      ),
      headline4: TextStyle(
        fontSize: 35.0,
        color: HackRUColors.blue_grey,
      ),
      headline5: TextStyle(
        fontSize: 25.0,
        color: HackRUColors.blue_grey,
        fontWeight: FontWeight.w700,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        color: HackRUColors.blue_grey,
        fontWeight: FontWeight.w700,
      ),
      subtitle1: TextStyle(
        fontSize: 18.0,
        color: HackRUColors.blue_grey,
        fontWeight: FontWeight.w700,
      ),
      bodyText1: TextStyle(
        color: HackRUColors.blue_grey,
      ),
      bodyText2: TextStyle(
        color: HackRUColors.blue_grey,
      ),
    ),
  );

  return base;
}
