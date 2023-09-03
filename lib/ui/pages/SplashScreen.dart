import 'package:flutter/material.dart';
import 'package:hackru/ui/widgets/Cloud.dart';
import '../../defaults.dart';
import '../../weather/bg/weather_bg.dart';
import '../../weather/utils/weather_type.dart';
import '../widgets/floating_island.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff73bb67),
                Color(0xff1e3427),
              ],
            ),
          ),
        ),
        WeatherBg(
            weatherType: WeatherType.sunnyNight,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height),
        FloatingIsland(
          floatDistance: 0.01,
          floatDuration: 2000,
          top: 0.1,
          left: 0.03,
          speed: 0.05,
          size: 0.95,
          imageName: "assets/assets-png/whale_island.PNG",
        ),
        Positioned(
            top: 0.55 * screenHeight,
            left: 0.05 * screenWidth,
            child: Container(
              width: 0.9 * screenWidth,
              child: Image.asset("assets/hackru-logos/hackru_yellow.png"),
            ))
      ],
    ));
  }
}
