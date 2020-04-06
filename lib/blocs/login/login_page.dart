import 'package:HackRU/models/models.dart';
import 'package:HackRU/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/authentication.dart';
import 'login.dart';

class LoginPage extends StatefulWidget {
//  final LcsCredential lcsCredential;

  const LoginPage({Key key}) : super(key: key);
//  LoginPage({Key key, @required this.lcsCredential})
//      : assert(lcsCredential != null),
//        super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
//    _loginBloc = LoginBloc(
//      lcsCredential: widget.lcsCredential,
//      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
//    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: transparent,
        brightness: Brightness.dark,
        elevation: 0.0,
      ),
      body: Center(
        child: LoginForm(),
      ),
//      body: Center(
//        child: BlocProvider(
//          create: (context) {
//            return _loginBloc;
//          },
//          child: LoginForm(lcsCredential: widget.lcsCredential),
//        ),
//      ),
    );
  }

  @override
  void dispose() {
//    _loginBloc.close();
    super.dispose();
  }
}