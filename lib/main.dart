import 'package:HackRU/blocs/auth/authentication.dart';
import 'package:HackRU/blocs/bloc_delegate.dart';
import 'package:HackRU/defaults.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/ui/hackru_app.dart';
import 'package:HackRU/ui/pages/map.dart';
import 'package:HackRU/ui/widgets/SplashScreen.dart';
import 'package:HackRU/ui/widgets/loading_indicator.dart';
import 'package:HackRU/ui/widgets/page_not_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/authentication_bloc.dart';
import 'blocs/login/login.dart';
import 'styles.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: pink,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  final LcsCredential lcsCredential;
  const MainApp({Key key, this.lcsCredential}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      home: HackRUApp(lcsCredential: lcsCredential),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new LoginPage(),
        '/hackRUApp': (BuildContext context) => new HackRUMap(),
      },
      onUnknownRoute: (RouteSettings setting) {
        String unknownRoute = setting.name;
        return new MaterialPageRoute(
          builder: (context) => PageNotFound(
            title: unknownRoute,
          ),
        );
      },
    );
  }
}

///TODO: Yet to be implemented!

//void main() {
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//    statusBarColor: Colors.white,
//    statusBarIconBrightness: Brightness.light,
//    systemNavigationBarColor: Colors.black,
//    systemNavigationBarIconBrightness: Brightness.light,
//  ));
//
//  BlocSupervisor.delegate = AppBlocDelegate();
//  LcsCredential lcsCredential;
//  runApp(
//    BlocProvider<AuthenticationBloc>(
//      create: (BuildContext context) {
//        return AuthenticationBloc(lcsCredential: lcsCredential)..add(AppStarted());
//      },
//      child: MainApp(lcsCredential: lcsCredential),
//    ),
//  );
//}
//
//class MainApp extends StatelessWidget {
//
//  final LcsCredential lcsCredential;
//  const MainApp({Key key, this.lcsCredential}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: kAppTitle,
//      debugShowCheckedModeBanner: false,
//      theme: kLightTheme,
//      darkTheme: kDarkTheme,
//      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//        builder: (context, state) {
//          if (state is AuthenticationAuthenticated) {
//            return HackRUApp();
//          }
//          if (state is AuthenticationUnauthenticated) {
//            return LoginPage(lcsCredential: lcsCredential);
//          }
//          if (state is AuthenticationLoading) {
//            return FancyLoadingIndicator();
//          }
//          return SplashScreen();
//        },
//      ),
//      routes: <String, WidgetBuilder>{
//        '/login': (BuildContext context) => new LoginPage(lcsCredential: lcsCredential,),
//        '/hackRUApp': (BuildContext context) => new HackRUMap(),
//      },
//      onUnknownRoute: (RouteSettings setting) {
//        String unknownRoute = setting.name;
//        return new MaterialPageRoute(
//          builder: (context) => PageNotFound(
//            title: unknownRoute,
//          ),
//        );
//      },
//    );
//  }
//}
