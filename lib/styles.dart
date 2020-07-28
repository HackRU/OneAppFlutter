import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Palette
const pink_light = Color(0xFFe06969);
const pink = Color(0xFFC85151);
const web_link = Color(0xFF732d2d);
const pink_dark = Color(0xFF592323);
const green = Color(0xFF4FAB5F);
const yellow = Color(0xFFf1ba43);
var yellowLight = Colors.yellow.shade500;

/// Black & White
const white = Colors.white;
const off_white = Color(0xFFfff5e8);
const grey_light = Color(0xFFe1e6e8);
const grey = Color(0xFF898c8c);
const charcoal_light = Color(0xFF4a4a4a);
const charcoal = Color(0xFF292929);
const charcoal_dark = Color(0xFF1A1A1A);
const black = Colors.black;
const semi_transparent = Colors.black87;
const transparent = Color(0x00ffffff);
const box_shadow = Color(0x0d000000);
const overlay = Color.fromRGBO(0, 0, 0, 80);

const ada_pink = Color(0xFFB94B4B);
const ada_green = Color(0xFF3D854A);

const g_pink_yellow = LinearGradient(
  colors: [yellow, pink],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.0, 1.0],
  tileMode: TileMode.clamp,
);

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
final kLightTheme = _buildLightTheme();
final kDarkTheme = _buildDarkTheme();

///======================================
///             LIGHT THEME
///======================================
ThemeData _buildLightTheme() {
  final base = ThemeData(
    brightness: Brightness.light,
    primaryColor: pink,
    primaryColorLight: white,
    primaryColorDark: pink_dark,
    accentColor: yellow,
    backgroundColor: white,
    scaffoldBackgroundColor: white,
    fontFamily: 'TitilliumWeb',
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade200,
      thickness: 2.0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: charcoal_light, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      fillColor: charcoal_light,
      labelStyle: TextStyle(
        color: charcoal_light,
      ),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 100.0,
        color: white,
        fontWeight: FontWeight.w600,
      ),
      headline2: TextStyle(
        fontSize: 90.0,
        color: white,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 45.0,
        color: white,
      ),
      headline4: TextStyle(
        fontSize: 35.0,
        color: white,
      ),
      headline5: TextStyle(
        fontSize: 25.0,
        color: charcoal_light,
        fontWeight: FontWeight.w700,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        color: charcoal_light,
        fontWeight: FontWeight.w700,
      ),
      subtitle1: TextStyle(
        fontSize: 18.0,
        color: charcoal_light,
        fontWeight: FontWeight.w700,
      ),
      bodyText1: TextStyle(
        color: charcoal_light,
      ),
      bodyText2: TextStyle(
        color: charcoal_light,
      ),
    ),
    primaryTextTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 100.0,
        color: pink,
        fontWeight: FontWeight.w600,
      ),
      headline2: TextStyle(
        fontSize: 90.0,
        color: pink,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 45.0,
        color: pink,
      ),
      headline4: TextStyle(
        fontSize: 35.0,
        color: pink,
      ),
      headline5: TextStyle(
        fontSize: 25.0,
        color: pink,
        fontWeight: FontWeight.w700,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        color: pink,
        fontWeight: FontWeight.w700,
      ),
      subtitle1: TextStyle(
        fontSize: 18.0,
        color: pink,
        fontWeight: FontWeight.w700,
      ),
      bodyText1: TextStyle(
        color: pink,
      ),
      bodyText2: TextStyle(
        color: pink,
      ),
    ),
    accentTextTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 100.0,
        color: yellow,
        fontWeight: FontWeight.w600,
      ),
      headline2: TextStyle(
        fontSize: 90.0,
        color: yellow,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 45.0,
        color: yellow,
      ),
      headline4: TextStyle(
        fontSize: 35.0,
        color: yellow,
      ),
      headline5: TextStyle(
        fontSize: 25.0,
        color: charcoal_light,
        fontWeight: FontWeight.w700,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        color: yellow,
        fontWeight: FontWeight.w700,
      ),
      subtitle1: TextStyle(
        fontSize: 18.0,
        color: yellow,
        fontWeight: FontWeight.w700,
      ),
      bodyText1: TextStyle(
        color: yellow,
      ),
      bodyText2: TextStyle(
        color: yellow,
      ),
    ),
  );

  return base;
}

///======================================
///             DARK THEME
///======================================
ThemeData _buildDarkTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    primaryColor: pink_light,
    primaryColorLight: pink_light,
    primaryColorDark: pink,
    accentColor: yellow,
    backgroundColor: charcoal,
    scaffoldBackgroundColor: charcoal,
    canvasColor: transparent,
    fontFamily: 'TitilliumWeb',
    dividerTheme: DividerThemeData(
      color: charcoal_light,
      thickness: 2.0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: pink_light, width: 0.0),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      fillColor: pink,
      labelStyle: TextStyle(
        color: pink_light,
      ),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 100.0,
        color: white,
        fontWeight: FontWeight.w200,
      ),
      headline2: TextStyle(
        fontSize: 90.0,
        color: white,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 45.0,
        color: white,
      ),
      headline4: TextStyle(
        fontSize: 35.0,
        color: white,
      ),
      headline5: TextStyle(
        fontSize: 25.0,
        color: white,
        fontWeight: FontWeight.w200,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        color: white,
        fontWeight: FontWeight.w200,
      ),
      subtitle1: TextStyle(
        fontSize: 18.0,
        color: white,
      ),
      bodyText1: TextStyle(
        color: white,
      ),
      bodyText2: TextStyle(
        color: white,
      ),
    ),
    primaryTextTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 100.0,
        color: pink_light,
        fontWeight: FontWeight.w200,
      ),
      headline2: TextStyle(
        fontSize: 90.0,
        color: pink_light,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 45.0,
        color: pink_light,
      ),
      headline4: TextStyle(
        fontSize: 35.0,
        color: pink_light,
      ),
      headline5: TextStyle(
        fontSize: 25.0,
        color: pink_light,
        fontWeight: FontWeight.w200,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        color: pink_light,
        fontWeight: FontWeight.w200,
      ),
      subtitle1: TextStyle(
        fontSize: 18.0,
        color: pink_light,
      ),
      bodyText1: TextStyle(
        color: pink_light,
      ),
      bodyText2: TextStyle(
        color: pink_light,
      ),
    ),
    accentTextTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 100.0,
        color: yellow,
        fontWeight: FontWeight.w200,
      ),
      headline2: TextStyle(
        fontSize: 90.0,
        color: yellow,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 45.0,
        color: yellow,
      ),
      headline4: TextStyle(
        fontSize: 35.0,
        color: yellow,
      ),
      headline5: TextStyle(
        fontSize: 25.0,
        color: yellow,
        fontWeight: FontWeight.w200,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        color: yellow,
        fontWeight: FontWeight.w200,
      ),
      subtitle1: TextStyle(
        fontSize: 18.0,
        color: yellow,
      ),
      bodyText1: TextStyle(
        color: yellow,
      ),
      bodyText2: TextStyle(
        color: yellow,
      ),
    ),
  );

  return base;
}
