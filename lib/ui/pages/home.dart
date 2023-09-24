import 'dart:async';

import 'package:hackru/ui/widgets/floating_island.dart';
import 'package:hackru/ui/widgets/sunrays.dart';
import 'package:hackru/weather/utils/weather_type.dart';
import 'package:hackru/weather/bg/weather_bg.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/ui/pages/annoucements/announcements.dart';
import 'package:hackru/ui/pages/dashboard/dashboard.dart';
import 'package:hackru/ui/pages/events/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/clouds.dart';
import 'help/help.dart';
import 'login/login_page.dart';

class Home extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';
  static String? userEmail;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentBottomNavItemIndex = 1;
  bool showHelp = false;
  bool showLogin = false;

  double pageOffset = 0;
  final PageController _pageController = PageController(initialPage: 1);

  void setHelp(bool val) => setState(() => showHelp = val);
  void setLogin(bool val) => setState(() => showLogin = val);

  final _bottomNavNames = [
    "Announcements",
    "DashBoard",
    "Events",
  ];
  final _bottomNavIcons = [
    Icons.announcement,
    Icons.dashboard,
    Icons.calendar_month,
  ];

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Row(
          children: [0, 1, 2]
              .map((idx) => bottNavBarIcon(
                  idx, _bottomNavNames[idx], _bottomNavIcons[idx]))
              .toList()),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() => pageOffset = _pageController.page!);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double widthToHeight = width / height;

    bool sm = widthToHeight < 0.6;
    bool md = widthToHeight >= 0.6 && widthToHeight < 1;
    bool lg = widthToHeight >= 1 && widthToHeight < 1.5;
    bool xl = widthToHeight >= 1.5;

    final _kBottomNavPages = <Widget>[
      const Announcements(),
      Dashboard(
        goToHelp: () => setHelp(true),
        goToLogin: () => setLogin(true),
      ),
      Events(),
    ];

    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xff73bb67),
              Color(0xff497847),
            ],
                stops: [
              0.3,
              0.7
            ])),
      ),
      WeatherBg(
          weatherType: WeatherType.sunnyNight, width: width, height: height),
      const Sunrays(),
      Clouds(MediaQuery.of(context).size.height),
      // whale island group
      FloatingIsland(
        floatDistance: 0.005,
        floatDuration: 2000,
        top: .225,
        left: lg || xl ? 0.35 : 0.05,
        pageController: _pageController,
        speed: 0.05,
        size: lg || xl ? 0.7 : 1,
        imageName: "assets/assets-png/whale_clouds.png",
      ),
      FloatingIsland(
        floatDistance: 0.01,
        floatDuration: 2000,
        top: xl
            ? 0.065
            : lg
                ? 0.125
                : 0.15,
        left: sm
            ? 0.2
            : md
                ? 0.35
                : lg
                    ? 0.5
                    : 0.55,
        pageController: _pageController,
        speed: 0.15,
        size: sm
            ? 1
            : md
                ? 0.8
                : lg
                    ? 0.6
                    : 0.525,
        imageName: "assets/assets-png/whale_island.PNG",
      ),
      FloatingIsland(
        floatDistance: 0.015,
        floatDuration: 2000,
        top: sm
            ? 0.525 + 0.85 * (widthToHeight - 0.462)
            : md
                ? 0.81 + 0.675 * (widthToHeight - 1)
                : lg
                    ? 0.87 + 0.5 * (widthToHeight - 1.5)
                    : 0.845 + 1 * (widthToHeight - 1.8),
        left: sm
            ? 0.83
            : md
                ? 0.86
                : 0.88,
        pageController: _pageController,
        speed: 0.15,
        size: sm
            ? 0.02
            : md
                ? 0.015
                : 0.0125,
        imageName: "assets/assets-png/small_island4.png",
      ),
      FloatingIsland(
        floatDistance: 0.0175,
        floatDuration: 2000,
        top: sm
            ? 0.5325 + 0.85 * (widthToHeight - 0.462)
            : md
                ? 0.82 + 0.675 * (widthToHeight - 1)
                : lg
                    ? 0.865 + 0.5 * (widthToHeight - 1.5)
                    : 0.85 + 1 * (widthToHeight - 1.8),
        left: xl
            ? 0.914
            : lg
                ? 0.9125
                : 0.9,
        pageController: _pageController,
        speed: 0.15,
        size: sm
            ? 0.02
            : md
                ? 0.015
                : 0.0125,
        imageName: "assets/assets-png/small_island4.png",
      ),

      // side island group
      FloatingIsland(
        floatDistance: 0.01,
        floatDuration: 2000,
        top: sm
            ? 0.575
            : md
                ? 0.45
                : 0.3,
        left: -0.05,
        pageController: _pageController,
        speed: 0.05,
        size: sm
            ? 0.25
            : md
                ? 0.2
                : 0.15,
        imageName: "assets/assets-png/side_island.png",
      ),
      FloatingIsland(
        floatDistance: 0.015,
        floatDuration: 2000,
        top: sm
            ? 0.685 + 0.3 * (widthToHeight - 0.462)
            : md
                ? 0.65 + 0.25 * (widthToHeight - 1)
                : 0.525 + 0.2 * (widthToHeight - 1.5),
        left: sm
            ? 0.1825
            : md
                ? 0.15
                : 0.1,
        pageController: _pageController,
        speed: 0.075,
        size: sm
            ? 0.12
            : md
                ? 0.1
                : 0.07,
        imageName: "assets/assets-png/small_island1.png",
      ),
      FloatingIsland(
        floatDistance: 0.015,
        floatDuration: 2000,
        top: sm
            ? 0.725 + 0.3 * (widthToHeight - 0.462)
            : md
                ? 0.71 + 0.25 * (widthToHeight - 1)
                : 0.575 + 0.2 * (widthToHeight - 1.5),
        left: sm ? 0.075 : 0.04,
        pageController: _pageController,
        speed: 0.075,
        size: sm
            ? 0.085
            : md
                ? 0.07
                : 0.05,
        imageName: "assets/assets-png/small_island2.png",
      ),

      showHelp
          ? Padding(
              padding: EdgeInsets.only(
                  top: 10,
                  right: widthToHeight > 1 ? width * 0.25 : 10,
                  left: widthToHeight > 1 ? width * 0.25 : 10),
              child: Help(
                  () => setHelp(false),
                  HackRUColors.transparent,
                  HackRUColors.pale_yellow,
                  Colors.black26,
                  HackRUColors.blue_grey),
            )
          : Container(),
      showLogin
          ? Padding(
              padding: EdgeInsets.only(
                  top: 10,
                  right: widthToHeight > 1 ? width * 0.25 : 10,
                  left: widthToHeight > 1 ? width * 0.25 : 10),
              child: Provider.value(
                  value: Provider.of<CredManager>(context),
                  child: LoginPage(goToDashboard: () => setLogin(false))),
            )
          : Container(),
      if (!(showLogin || showHelp))
        Padding(
          padding: EdgeInsets.only(
              top: 10,
              right: widthToHeight > 1 ? width * 0.25 : 10,
              left: widthToHeight > 1 ? width * 0.25 : 10),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top * 1.5),
              child: PageView(
                controller: _pageController,
                children: _kBottomNavPages,
                onPageChanged: (value) => setState(() {
                  _currentBottomNavItemIndex = value;
                }),
              ),
            ),
            bottomNavigationBar: _buildBottomAppBar(context),
          ),
        )
      else
        Container()
    ]);
  }

  Widget bottNavBarIcon(int index, String name, IconData icon) {
    return Expanded(
      flex: 2,
      child: InkResponse(
        onTap: () {
          setState(() {
            _currentBottomNavItemIndex = index;
          });
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 25.0,
                color: _currentBottomNavItemIndex == index
                    ? HackRUColors.white
                    : HackRUColors.charcoal_dark,
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: _currentBottomNavItemIndex == index ? 14.0 : 12.0,
                  color: _currentBottomNavItemIndex == index
                      ? HackRUColors.white
                      : HackRUColors.charcoal_dark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
