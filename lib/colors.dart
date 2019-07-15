import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//const mintgreen_dark = const Color(0xFF26E8BD);
//const mintgreen_light= const Color(0xFF5FFFDC);
//const bluegrey = const Color(0xFF5A7A96);
//const pink_dark = const Color(0xFFFF80CF);
//const pink_light = const Color(0xFFF8A5FF);
//const shadow = const Color(0xFFA9f6E5);
//const green_tab = const Color(0xFF1eb997);

const pink = const Color(0xFFC85151);
const green = const Color(0xFF4FAB5F);
const yellow = const Color(0xFFF1BA43);

const bluegrey = const Color(0xFF3E5569);

const white = Colors.white;
const grey_light = const Color(0xFFECEFF1);
const greyLight = const Color(0xFF898c8c);
const charcoal = const Color(0xFF24292E);
const black = Colors.black;
const charcoal_light = const Color(0xFF2f363d);

const transparent = const Color(0x263E5569);
var fb = Colors.lightBlue[400];

const g_pink_yellow = const LinearGradient(
    colors: [yellow, pink],
    begin: const FractionalOffset(0.4, 0.0),
    end: const FractionalOffset(0.0, 0.5),
    stops:[0.0,1.0],
    tileMode: TileMode.clamp
);