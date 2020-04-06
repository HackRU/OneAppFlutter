import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Palette
const pink_light = const Color(0xFFe06969);
const pink = const Color(0xFFC85151);
const web_link = const Color(0xFF732d2d);
const pink_dark = const Color(0xFF592323);
const green = const Color(0xFF4FAB5F);
const yellow = const Color(0xFFf1ba43);

/// Black & White
const white = Colors.white;
const off_white = const Color(0xFFfff5e8);
const grey_light = const Color(0xFFe1e6e8);
const grey = const Color(0xFF898c8c);
const charcoal_light = const Color(0xFF4a4a4a);
const charcoal = const Color(0xFF292929);
const charcoal_dark = const Color(0xFF1A1A1A);
const black = Colors.black;
const semi_transparent = Colors.black87;
const transparent = const Color(0x00ffffff);
const box_shadow = const Color(0x0d000000);
const overlay = const Color.fromRGBO(0, 0, 0, 80);

const ada_pink = const Color(0xFFB94B4B);
const ada_green = const Color(0xFF3D854A);

const g_pink_yellow = const LinearGradient(
    colors: [yellow, pink],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
);

/*
NAME       SIZE   WEIGHT   SPACING  2018 NAME
display4   112.0  thin     0.0      headline1
display3   56.0   normal   0.0      headline2
display2   45.0   normal   0.0      headline3
display1   34.0   normal   0.0      headline4
headline   24.0   normal   0.0      headline5
title      20.0   medium   0.0      headline6
subhead    16.0   normal   0.0      subtitle1
body2      14.0   medium   0.0      body1
body1      14.0   normal   0.0      body2
caption    12.0   normal   0.0      caption
button     14.0   medium   0.0      button
subtitle   14.0   medium   0.0      subtitle2
overline   10.0   normal   0.0      overline
*/

/// Themes
final kLightTheme = _buildLightTheme();
final kDarkTheme = _buildDarkTheme();

///---------------------------------------
///             LIGHT THEME
///---------------------------------------
ThemeData _buildLightTheme() {
  final ThemeData base = ThemeData(
    brightness: Brightness.light,
    primaryColor: pink,
    primaryColorLight: white,
    primaryColorDark: pink_dark,
    accentColor: yellow,
    backgroundColor: white,
    scaffoldBackgroundColor: white,
    fontFamily: 'TitilliumWeb',
    dividerTheme: DividerThemeData(
      color: grey_light,
      thickness: 2.0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: off_white, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      fillColor: off_white,
      labelStyle: TextStyle(
        color: off_white,
      ),
    ),
    textTheme: TextTheme(
      display4: TextStyle(fontSize: 100.0, color: white, fontWeight: FontWeight.w600,),
      display3: TextStyle(fontSize: 90.0, color: white, fontWeight: FontWeight.bold,),
      display2: TextStyle(fontSize: 45.0, color: white,),
      display1: TextStyle(fontSize: 35.0, color: white,),
      headline: TextStyle(fontSize: 25.0, color: charcoal_light, fontWeight: FontWeight.w700,),
      title: TextStyle(fontSize: 20.0, color: white, fontWeight: FontWeight.w700,),
      subhead: TextStyle(fontSize: 18.0, color: charcoal_light, fontWeight: FontWeight.w700,),
      body2: TextStyle(color: white,),
      body1: TextStyle(color: charcoal_light,),
    ),
    primaryTextTheme: TextTheme(
      display4: TextStyle(fontSize: 100.0, color: pink, fontWeight: FontWeight.w600,),
      display3: TextStyle(fontSize: 90.0, color: pink, fontWeight: FontWeight.bold,),
      display2: TextStyle(fontSize: 45.0, color: pink,),
      display1: TextStyle(fontSize: 35.0, color: pink,),
      headline: TextStyle(fontSize: 25.0, color: pink, fontWeight: FontWeight.w700,),
      title: TextStyle(fontSize: 20.0, color: pink, fontWeight: FontWeight.w700,),
      subhead: TextStyle(fontSize: 18.0, color: pink, fontWeight: FontWeight.w700,),
      body2: TextStyle(color: pink,),
      body1: TextStyle(color: pink,),
    ),
    accentTextTheme: TextTheme(
      display4: TextStyle(fontSize: 100.0, color: yellow, fontWeight: FontWeight.w600,),
      display3: TextStyle(fontSize: 90.0, color: yellow, fontWeight: FontWeight.bold,),
      display2: TextStyle(fontSize: 45.0, color: yellow,),
      display1: TextStyle(fontSize: 35.0, color: yellow,),
      headline: TextStyle(fontSize: 25.0, color: charcoal_light, fontWeight: FontWeight.w700,),
      title: TextStyle(fontSize: 20.0, color: yellow, fontWeight: FontWeight.w700,),
      subhead: TextStyle(fontSize: 18.0, color: yellow, fontWeight: FontWeight.w700,),
      body2: TextStyle(color: yellow,),
      body1: TextStyle(color: yellow,),
    ),
  );

  return base;
}

///---------------------------------------
///             DARK THEME
///---------------------------------------
ThemeData _buildDarkTheme() {
  final ThemeData base = ThemeData(
    brightness: Brightness.dark,
    primaryColor: pink,
    primaryColorLight: pink_light,
    primaryColorDark: pink_dark,
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
      display4: TextStyle(fontSize: 100.0, color: white, fontWeight: FontWeight.w200,),
      display3: TextStyle(fontSize: 90.0, color: white, fontWeight: FontWeight.bold,),
      display2: TextStyle(fontSize: 45.0, color: white,),
      display1: TextStyle(fontSize: 35.0, color: white,),
      headline: TextStyle(fontSize: 25.0, color: white, fontWeight: FontWeight.w200,),
      title: TextStyle(fontSize: 20.0, color: white, fontWeight: FontWeight.w200,),
      subhead: TextStyle(fontSize: 18.0, color: white,),
      body2: TextStyle(color: white,),
      body1: TextStyle(color: white,),
    ),
    primaryTextTheme: TextTheme(
      display4: TextStyle(fontSize: 100.0, color: pink_light, fontWeight: FontWeight.w200,),
      display3: TextStyle(fontSize: 90.0, color: pink_light, fontWeight: FontWeight.bold,),
      display2: TextStyle(fontSize: 45.0, color: pink_light,),
      display1: TextStyle(fontSize: 35.0, color: pink_light,),
      headline: TextStyle(fontSize: 25.0, color: pink_light, fontWeight: FontWeight.w200,),
      title: TextStyle(fontSize: 20.0, color: pink_light, fontWeight: FontWeight.w200,),
      subhead: TextStyle(fontSize: 18.0, color: pink_light,),
      body2: TextStyle(color: pink_light,),
      body1: TextStyle(color: pink_light,),
    ),
    accentTextTheme: TextTheme(
      display4: TextStyle(fontSize: 100.0, color: yellow, fontWeight: FontWeight.w200,),
      display3: TextStyle(fontSize: 90.0, color: yellow, fontWeight: FontWeight.bold,),
      display2: TextStyle(fontSize: 45.0, color: yellow,),
      display1: TextStyle(fontSize: 35.0, color: yellow,),
      headline: TextStyle(fontSize: 25.0, color: yellow, fontWeight: FontWeight.w200,),
      title: TextStyle(fontSize: 20.0, color: yellow, fontWeight: FontWeight.w200,),
      subhead: TextStyle(fontSize: 18.0, color: yellow,),
      body2: TextStyle(color: yellow,),
      body1: TextStyle(color: yellow,),
    ),
  );

  return base;
}