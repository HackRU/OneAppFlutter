import 'package:hackru/weather/utils/weather_type.dart';
import 'package:hackru/weather/bg/weather_bg.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/ui/pages/annoucements/announcements.dart';
import 'package:hackru/ui/pages/dashboard/dashboard.dart';
import 'package:hackru/ui/pages/events/events.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';
  static String? userEmail;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentBottomNavItemIndex = 1;
  CredManager? credManager;

  final PageController _pageController = PageController(initialPage: 1);

  ///===========================================================
  ///                     BOTTOM NAV PAGES
  ///===========================================================
  final _kBottomNavPages = <Widget>[
    Announcements(),
    Dashboard(),
    Events(),
  ];
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

  ///===========================================================
  ///                      BOTTOM APP BAR
  ///===========================================================
  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      elevation: 25.0,
      notchMargin: 6.0,
      color: Colors.transparent,
      child: Row(
          children: [0, 1, 2]
              .map((idx) => bottNavBarIcon(
                  idx, _bottomNavNames[idx], _bottomNavIcons[idx]))
              .toList()),
    );
  }

  ///===========================================================
  ///                     BUILD FUNCTION
  ///===========================================================

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      WeatherBg(
          weatherType: WeatherType.sunnyNight,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: PageView(
            controller: _pageController,
            children: _kBottomNavPages,
            onPageChanged: (value) => setState(() {
              _currentBottomNavItemIndex = value;
            }),
          ),
        ),
        bottomNavigationBar: _buildBottomAppBar(context),
      )
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
