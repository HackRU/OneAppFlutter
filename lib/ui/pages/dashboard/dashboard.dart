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
import '../../widgets/timer_text.dart';
import '../help/help.dart';
import '../home.dart';
import '../login/login_page.dart';
import '../qr_scanner/Scanner.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

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

  Future _scanDialogWarning(String body) async {
    return showDialog(
      context: context,
      builder: (BuildContext context, {barrierDismissible = false}) {
        return AlertDialog(
          backgroundColor: HackRUColors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Icon(
            Icons.people,
            color: HackRUColors.off_white,
            size: 50.0,
          ),
          content: Text(body,
              style:
                  const TextStyle(fontSize: 50, color: HackRUColors.off_white),
              textAlign: TextAlign.center),
          actions: <Widget>[
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              splashColor: HackRUColors.yellow,
              height: 40.0,
              color: HackRUColors.off_white,
              onPressed: () async {
                Navigator.pop(context, true);
              },
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 20,
                  color: HackRUColors.pink,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onLogin() async {
    var loginResponse;
    var hasCred = credManager!.hasCredentials();
    if (hasCred) {
    } else {
      loginResponse = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Provider.value(value: credManager!, child: const LoginPage()),
          fullscreenDialog: true,
        ),
      );
    }
    if (loginResponse != null && loginResponse != '' && mounted) {
      ScaffoldMessengerState().clearSnackBars();
      ScaffoldMessengerState().showSnackBar(
        SnackBar(
          content: Text(await loginResponse ?? ''),
          backgroundColor: HackRUColors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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

  void _onGetAttending() async {
    var _storedEmail = credManager!.getEmail();
    var _authToken = credManager!.getAuthToken();
    var count = 0;
    try {
      count = await getAttending(_authToken);
      _scanDialogWarning("Total = " + count.toString());
    } on LcsError {
      var result = "Error Fetching Result.";
      _scanDialogWarning(result);
    }
  }

  void _onHelp() =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => Help()));

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
              width: MediaQuery.of(context).size.width * 0.75,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: timerBanner(Colors.black12, HackRUColors.blue_grey),
          ),
          if (_hasAuthToken) ...[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.black12,
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
                                        color: HackRUColors.blue_grey,
                                        height: 33.33,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Shimmer(
                                    gradient: HackRUColors.loading_gradient,
                                    child: Container(
                                        color: HackRUColors.blue_grey,
                                        height: 28.33,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5))
                              ],
                            ),
                            Shimmer(
                              child: Container(
                                height: 35,
                                width: 35,
                                color: HackRUColors.blue_grey,
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
                                    fontFamily: 'titilliumWeb',
                                    fontSize: 25,
                                    color: HackRUColors.blue_grey,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        userStatus,
                                        style: TextStyle(
                                          fontFamily: 'titilliumWeb',
                                          fontSize: 18,
                                          color: HackRUColors.blue_grey,
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
                                              ? Colors.green
                                              : Colors.red,
                                          size: 30.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  _showQrCode();
                                },
                                icon: const Icon(
                                  Icons.qr_code,
                                  size: 24,
                                ))
                          ],
                        ),
                ),
              ),
            ),
          ] else
            const SizedBox(height: 5),
          Row(
            children: [
              if (!_hasAuthToken)
                Expanded(
                  child: DashboardButton(
                      onPressed: _onLogin,
                      bgColor: HackRUColors.blue,
                      textColor: HackRUColors.blue_grey,
                      label: "Login"),
                ),
              Expanded(
                child: DashboardButton(
                    onPressed: _onHelp,
                    bgColor: Colors.black12,
                    textColor: HackRUColors.blue_grey,
                    label: "Help"),
              )
            ],
          ),
          if (credManager!.getAuthorization()) ...[
            const SizedBox(height: 5),
            DashboardButton(
                onPressed: _onScanner,
                bgColor: Colors.black12,
                textColor: HackRUColors.blue_grey,
                label: "QR Scanner")
          ],
          if (credManager!.getAuthorization()) ...[
            const SizedBox(height: 5),
            DashboardButton(
                onPressed: _onGetAttending,
                bgColor: Colors.black12,
                textColor: HackRUColors.blue_grey,
                label: "Get Attending")
          ],
          if (_hasAuthToken) ...[
            const SizedBox(height: 5),
            DashboardButton(
                onPressed: _onLogout,
                bgColor: Colors.black12,
                textColor: HackRUColors.blue_grey,
                label: "Logout")
          ],
          Expanded(child: Container()),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SocialMediaCard(
                onPressed: () => url_launcher.launch(HACK_RU_WEBSITE_URL),
                iconData: FontAwesomeIcons.link,
                iconColor: HackRUColors.blue_grey,
                bgColor: Colors.transparent,
              ),
              SocialMediaCard(
                onPressed: () => url_launcher.launch(REPOSITORY_URL),
                iconData: FontAwesomeIcons.github,
                iconColor: HackRUColors.blue_grey,
                bgColor: Colors.transparent,
              ),
              SocialMediaCard(
                onPressed: () => url_launcher.launch(FACEBOOK_PAGE_URL),
                iconData: FontAwesomeIcons.squareFacebook,
                iconColor: HackRUColors.blue_grey,
                bgColor: Colors.transparent,
              ),
              SocialMediaCard(
                onPressed: () => url_launcher.launch(INSTAGRAM_PAGE_URL),
                iconData: FontAwesomeIcons.instagram,
                iconColor: HackRUColors.blue_grey,
                bgColor: Colors.transparent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
