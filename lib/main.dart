import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackru/defaults.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/ui/pages/home.dart';
import 'package:hackru/ui/widgets/page_not_found.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_strategy/url_strategy.dart';
import 'styles.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(AnnouncementAdapter());

  CredManager credManager = CredManager(await Hive.openBox("prefs"));
  Box cachedAnnouncements = await Hive.openBox<Announcement>("announcements");
  await Hive.openBox("loading");

  /*  ======================================================== *
   *  SYSTEM UI OVERLAY STYLING (ANDROID)                      *
   *  ======================================================== */
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: HackRUColors.black,
    ),
  );

  setPathUrlStrategy();
  runApp(MainApp(
    credManager: credManager,
    cachedAnnouncements: cachedAnnouncements,
  ));
}

class MainApp extends StatelessWidget {
  final LcsCredential? lcsCredential;
  final CredManager credManager;
  final Box cachedAnnouncements;
  const MainApp({
    Key? key,
    this.lcsCredential,
    required this.credManager,
    required this.cachedAnnouncements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: kTheme,
      home: MultiProvider(providers: [
        Provider.value(value: credManager),
        Provider.value(value: cachedAnnouncements),
      ], child: Home()),
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
