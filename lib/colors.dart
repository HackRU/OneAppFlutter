import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const mintgreen_dark = const Color(0xFF26E8BD);
const mintgreen_light= const Color(0xFF5FFFDC);
const bluegrey = const Color(0xFF5A7A96);
const pink_dark = const Color(0xFFFF80CF);
const pink_light = const Color(0xFFF8A5FF);

const white = Colors.white;
const black = Colors.black;
const bluegrey_dark = const Color(0xFF3E5569);
const grey_light = const Color(0xFFECEFF1);
const shadow = const Color(0xFFA9f6E5);
const green_tab = const Color(0xFF1eb997);

const g_blueDark_blueLight = const LinearGradient(
    colors: [mintgreen_dark, bluegrey],
    begin: const FractionalOffset(0.4, 0.0),
    end: const FractionalOffset(0.0, 0.5),
    stops:[0.0,1.0],
    tileMode: TileMode.clamp
);