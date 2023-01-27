import 'package:hackru/weather/utils/weather_type.dart';
import 'package:hackru/weather/bg/weather_bg.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/ui/pages/annoucements/announcements.dart';
import 'package:hackru/ui/pages/dashboard/dashboard.dart';
import 'package:hackru/ui/pages/events/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    final _kBottomNavPages = <Widget>[
      Announcements(),
      Dashboard(
        goToHelp: () => setHelp(true),
        goToLogin: () => setLogin(true),
      ),
      Events(),
    ];

    return Stack(children: [
      WeatherBg(
          weatherType: WeatherType.sunnyNight,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height),
      showHelp
          ? Help(
              () => setHelp(false),
              HackRUColors.transparent,
              HackRUColors.off_white_blue,
              Colors.black26,
              HackRUColors.blue_grey)
          : Container(),
      showLogin
          ? Provider.value(
              value: Provider.of<CredManager>(context),
              child: LoginPage(goToDashboard: () => setLogin(false)))
          : Container(),
      if (!(showLogin || showHelp))
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height >
                      1
                  ? MediaQuery.of(context).size.width * 0.25
                  : 10),
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
