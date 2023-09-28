import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackru/defaults.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/ui/pages/home.dart';
import 'package:hackru/ui/widgets/page_not_found.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_strategy/url_strategy.dart';
import 'services/cache_service.dart';
import 'styles.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(AnnouncementAdapter());
  Hive.registerAdapter(EventAdapter());

  CredManager credManager = CredManager(await Hive.openBox("prefs"));
  Box cachedAnnouncements = await Hive.openBox<Announcement>("announcements");
  Box cachedEvents = await Hive.openBox<Event>("events");
  await Hive.openBox("loading");
  getSlacks();
  getEvents();

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
    cachedEvents: cachedEvents,
  ));
}

class MainApp extends StatelessWidget {
  final LcsCredential? lcsCredential;
  final CredManager credManager;
  final Box cachedAnnouncements;
  final Box cachedEvents;
  const MainApp({
    Key? key,
    this.lcsCredential,
    required this.credManager,
    required this.cachedAnnouncements,
    required this.cachedEvents,
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
        Provider.value(value: cachedEvents),
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
