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

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentBottomNavItemIndex = 1;
  CredManager? credManager;

  final PageController _pageController = PageController(initialPage: 1);

  ///===========================================================
  ///                     BOTTOM NAV PAGES
  ///===========================================================
  final _kBottomNavPages = <Widget>[Announcements(), Dashboard(), Events()];
  final _bottomNavNames = ["Announcements", "DashBoard", "Events"];

  ///===========================================================
  ///                      BOTTOM APP BAR
  ///===========================================================
  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      elevation: 25.0,
      notchMargin: 6.0,
      color: Theme.of(context).primaryColor,
      child: Row(
          children: [0, 1, 2]
              .map((idx) => bottNavBarIcon(idx, _bottomNavNames[idx]))
              .toList()),
    );
  }

  ///===========================================================
  ///                     BUILD FUNCTION
  ///===========================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: PageView(
            controller: _pageController,
            children: _kBottomNavPages,
            onPageChanged: (value) => setState(() {
              _currentBottomNavItemIndex = value;
            }),
          ),
          bottomNavigationBar: _buildBottomAppBar(context),
        ),
      ),
    );
  }

  Widget bottNavBarIcon(int index, String name) {
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
                Icons.announcement,
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
