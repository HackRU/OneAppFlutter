import 'package:flutter/material.dart';
import '../../defaults.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          kAppIcon,
          height: 150.0,
        ),
      ),
    );
  }
}
