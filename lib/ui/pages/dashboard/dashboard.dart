import 'dart:async';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hackru/ui/widgets/social_media.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:hackru/defaults.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../widgets/dashboard_button.dart';
import '../../widgets/dialog/warning_dialog.dart';
import '../../widgets/timer_text.dart';
import '../help/help.dart';
import '../home.dart';
import '../login/login_page.dart';
import '../qr_scanner/Scanner.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({required this.goToHelp, required this.goToLogin});
  final VoidCallback goToHelp;
  final VoidCallback goToLogin;

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  String _storedEmail = "";
  String username = "";
  String userStatus = "";
  bool _hasAuthToken = false;
  String registrationStatus = "checked in";
  bool checkedin = false;
  String tempStatus = "";
  CredManager? credManager;
  bool _isLoading = true;

  @override
  void initState() {
    credManager = Provider.of<CredManager>(context, listen: false);
    super.initState();
    _hasToken();
    _getUserName();
  }

  void _hasToken() async {
    var hasToken = credManager!.hasCredentials();
    if (mounted) {
      if (hasToken) {
        setState(() {
          _hasAuthToken = true;
        });
      } else {
        setState(() {
          _hasAuthToken = false;
        });
      }
    }
  }

  void _getUserName() async {
    _storedEmail = credManager!.getEmail();
    if (_storedEmail != "") {
      var _authToken = credManager!.getAuthToken();
      var userProfile = await getUser(_authToken, _storedEmail);
      if (mounted) {
        setState(() {
          username = userProfile.firstName + " " + userProfile.lastName;
          tempStatus = userProfile.registrationStatus;
          if (userProfile.registrationStatus == "checked-in") {
            checkedin = true;
            userStatus = "You're checked-in!";
          } else {
            checkedin = false;
            userStatus = "You're not checked in yet.";
          }
        });
      }
    }
    _isLoading = false;
  }

  void _onLogin() async {
    if (!credManager!.hasCredentials()) widget.goToLogin();
  }

  void _onLogout() async {
    credManager!.deleteCredentials();
    setState(() {
      _hasAuthToken = false;
    });
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            Provider.value(value: credManager!, child: Home()),
        maintainState: false,
      ),
      ModalRoute.withName('/main'),
    );
  }

  void _onGetRegistered(BuildContext context) async {
    var _storedEmail = credManager!.getEmail();
    var _authToken = credManager!.getAuthToken();
    var count = 0;
    try {
      count = await getRegistered(_authToken);
      warningDialog(
          context,
          "Total = " + count.toString(),
          const Color.fromARGB(255, 19, 61, 53),
          HackRUColors.pale_yellow,
          HackRUColors.white);
    } on LcsError {
      var result = "Error Fetching Result.";
      warningDialog(context, result, HackRUColors.blue,
          HackRUColors.pale_yellow, HackRUColors.blue_grey);
    }
  }

  void _onGetAttending(BuildContext context) async {
    var _storedEmail = credManager!.getEmail();
    var _authToken = credManager!.getAuthToken();
    var count = 0;
    try {
      count = await getAttending(_authToken);
      warningDialog(
          context,
          "Total = " + count.toString(),
          const Color.fromARGB(255, 19, 61, 53),
          HackRUColors.pale_yellow,
          HackRUColors.white);
    } on LcsError {
      var result = "Error Fetching Result.";
      warningDialog(context, result, HackRUColors.blue,
          HackRUColors.pale_yellow, HackRUColors.blue_grey);
    }
  }

  void _onHelp() => widget.goToHelp();

  void _onScanner() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) =>
              Provider.value(value: credManager, child: const Scanner())));

  ///===========================================================
  ///                      SHOW QR-CODE
  ///===========================================================
  void _showQrCode() async {
    var userEmail = credManager!.getEmail();
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HackRUColors.white,
                    HackRUColors.white,
                  ],
                ),
              ),
              width: (MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height <
                      1)
                  ? MediaQuery.of(context).size.width * 0.75
                  : MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Center(
                child: QrImage(
                  version: 4,
                  data: userEmail,
                  gapless: true,
                  embeddedImage: const AssetImage(
                      'assets/hackru-logos/appIconImageWhite.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(50, 50),
                  ),
                  foregroundColor: HackRUColors.charcoal,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
        );
      },
    )) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          timerBanner(Colors.black26, HackRUColors.pale_yellow),
          const SizedBox(height: 7.5),
          if (_hasAuthToken) ...[
            Container(
              decoration: ShapeDecoration(
                color: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer(
                                  gradient: HackRUColors.loading_gradient,
                                  child: Container(
                                      color: HackRUColors.black,
                                      height: 33.33,
                                      width: MediaQuery.of(context).size.width *
                                          0.6)),
                              const SizedBox(
                                height: 7.5,
                              ),
                              Shimmer(
                                  gradient: HackRUColors.loading_gradient,
                                  child: Container(
                                      color: HackRUColors.black,
                                      height: 24,
                                      width: MediaQuery.of(context).size.width *
                                          0.5))
                            ],
                          ),
                          Shimmer(
                            child: Container(
                              height: 35,
                              width: 35,
                              color: HackRUColors.black,
                            ),
                            gradient: HackRUColors.loading_gradient,
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: HackRUColors.pale_yellow,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      userStatus,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: HackRUColors.pale_yellow,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        IconData(checkedin ? 0xe157 : 0xf68b,
                                            fontFamily: 'MaterialIcons'),
                                        color: checkedin
                                            ? Color(0xff73bb67)
                                            : Colors.red,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _showQrCode();
                                      },
                                      color: HackRUColors.pale_yellow,
                                      icon: const Icon(
                                        Icons.qr_code,
                                        size: 40,
                                      )),
                                  const SizedBox(
                                    width: 5,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              )
                            ],
                          )
                        ],
                      ),
              ),
            ),
            // const SizedBox(height: 7.5),
          ],
          Row(
            children: [
              if (!_hasAuthToken) ...[
                Expanded(
                  child: DashboardButton(
                      onPressed: _onLogin,
                      bgColor: const Color.fromARGB(255, 19, 61, 53),
                      textColor: HackRUColors.pale_yellow,
                      label: "Login"),
                ),
                Expanded(
                  child: DashboardButton(
                      onPressed: _onHelp,
                      bgColor: Colors.black26,
                      textColor: HackRUColors.pale_yellow,
                      label: "Help"),
                )
              ]
            ],
          ),
          if (credManager!.getAuthorization()) ...[
            const SizedBox(height: 7.5),
            DashboardButton(
                onPressed: _onScanner,
                bgColor: Colors.black26,
                textColor: HackRUColors.pale_yellow,
                label: "QR Scanner"),
            // const SizedBox(height: 7.5),
            // DashboardButton(
            //     onPressed: () => _onGetRegistered(context),
            //     bgColor: Colors.black26,
            //     textColor: HackRUColors.pale_yellow,
            //     label: "Get Registered"),
            const SizedBox(height: 7.5),
            DashboardButton(
                onPressed: () => _onGetAttending(context),
                bgColor: Colors.black26,
                textColor: HackRUColors.pale_yellow,
                label: "Get Attending")
          ],
          if (_hasAuthToken) ...[
            const SizedBox(height: 7.5),
            DashboardButton(
                onPressed: _onHelp,
                bgColor: Colors.black26,
                textColor: HackRUColors.pale_yellow,
                label: "Helpful Links"),
            const SizedBox(height: 7.5),
            DashboardButton(
                onPressed: _onLogout,
                bgColor: Colors.black26,
                textColor: HackRUColors.pale_yellow,
                label: "Logout")
          ],
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SocialMediaCard(
                  onPressed: () => url_launcher.launch(HACK_RU_WEBSITE_URL),
                  iconData: FontAwesomeIcons.link,
                  iconColor: HackRUColors.pale_yellow,
                  bgColor: Colors.black26,
                ),
                SocialMediaCard(
                  onPressed: () => url_launcher.launch(REPOSITORY_URL),
                  iconData: FontAwesomeIcons.github,
                  iconColor: HackRUColors.pale_yellow,
                  bgColor: Colors.black26,
                ),
                SocialMediaCard(
                  onPressed: () => url_launcher.launch(FACEBOOK_PAGE_URL),
                  iconData: FontAwesomeIcons.squareFacebook,
                  iconColor: HackRUColors.pale_yellow,
                  bgColor: Colors.black26,
                ),
                SocialMediaCard(
                  onPressed: () => url_launcher.launch(INSTAGRAM_PAGE_URL),
                  iconData: FontAwesomeIcons.instagram,
                  iconColor: HackRUColors.pale_yellow,
                  bgColor: Colors.black26,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
