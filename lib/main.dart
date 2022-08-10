import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackru/defaults.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/ui/hackru_app.dart';
import 'package:hackru/ui/pages/login/login_page.dart';
import 'package:hackru/ui/widgets/page_not_found.dart';
import 'package:url_strategy/url_strategy.dart';
import 'styles.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ====== TODO: update following configs
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//     BehaviorSubject<ReceivedNotification>();

// final BehaviorSubject<String> selectNotificationSubject =
//     BehaviorSubject<String>();

// NotificationAppLaunchDetails? notificationAppLaunchDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ====== TODO: update following configs
  // notificationAppLaunchDetails = await flutterLocalNotificationsPlugin
  //     .getNotificationAppLaunchDetails();

  // var initializationSettingsAndroid =
  // AndroidInitializationSettings('app_icon_transparent');

  // var initializationSettingsIOS = IOSInitializationSettings(
  //     requestAlertPermission: false,
  //     requestBadgePermission: false,
  //     requestSoundPermission: false,
  //     onDidReceiveLocalNotification:
  //         (int id, String title, String body, String payload) async {
  //       didReceiveLocalNotificationSubject.add(ReceivedNotification(
  //           id: id, title: title, body: body, payload: payload));
  //     });

  // var initializationSettings = InitializationSettings(
  //     initializationSettingsAndroid, initializationSettingsIOS);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String payload) async {
  //       if (payload != null) {
  //         debugPrint('notification payload: ' + payload);
  //       }
  //       selectNotificationSubject.add(payload);
  //     });

  /*  ======================================================== *
   *  SYSTEM UI OVERLAY STYLING (ANDROID)                      *
   *  ======================================================== */
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: HackRUColors.black,
    ),
  );

  setPathUrlStrategy();
  runApp(const MainApp());
}

/// =======================================================
///                    RECEIVED NOTIFICATION
/// =======================================================

// class ReceivedNotification {
//   final int? id;
//   final String? title;
//   final String? body;
//   final String? payload;

//   ReceivedNotification({
//     @required this.id,
//     @required this.title,
//     @required this.body,
//     @required this.payload,
//   });
// }

class MainApp extends StatelessWidget {
  final LcsCredential? lcsCredential;
  const MainApp({Key? key, this.lcsCredential}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      home: HackRUApp(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginPage(),
        '/home': (BuildContext context) => HackRUApp(),
        // '/floorMap': (BuildContext context) => HackRUMap(),
      },
      onUnknownRoute: (RouteSettings setting) {
        var unknownRoute = setting.name;
        return MaterialPageRoute(
          builder: (context) => PageNotFound(
            title: unknownRoute,
          ),
        );
      },
    );
  }
}
