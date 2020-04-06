import 'package:HackRU/blocs/login/login.dart';
import 'package:HackRU/models/cred_manager.dart';
import 'package:HackRU/models/exceptions.dart';
import 'package:HackRU/styles.dart';
import 'package:HackRU/defaults.dart';
import 'package:HackRU/services/hackru_service.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/ui/pages/home.dart';
import 'package:HackRU/ui/pages/scanner.dart';
import 'package:HackRU/ui/widgets/error_dialog.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {

  const LoginForm({Key key}) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _inputIsValid = true;
  var _isEmailEntered = false;
  static var credStr = '';
  static var guestUser;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context){

    _launchUrl() async {
      const url = HACKRU_SIGN_UP;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    void _errorDialog(String body) async {
      switch (await showDialog(
        context: context,
        builder: (BuildContext context, {barrierDismissible: false}) {
          return new ErrorDialog(body: body);
        },
      )) {}
    }

    _onLoginButtonPressed(){
      if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
        var error = 'Error:\n Missing username and/or password!';
        _errorDialog(error);
      }
      else{
        LoginButtonPressed(
          username: _emailController.text,
          password: _passwordController.text,
        );
//        BlocProvider.of<LoginBloc>(context).add(
//          LoginButtonPressed(
//            username: _emailController.text,
//            password: _passwordController.text,
//          ),
//        );
      }
    }

    Widget kForm(){
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(25.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 25.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 5.0),
                    child: Container(
                      height: 150.0,
                      child: FlareActor(
                        'assets/flare/hackru_logo.flr',
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "idle",
                      ),
                    ),
                  ),
                  Text(kSeasonTitle, style: Theme.of(context).textTheme.title,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20, color: off_white),
                controller: _emailController,
                onChanged: (value){
                  value.isNotEmpty ?
                  setState(() { _isEmailEntered = true; })
                      : setState(() { _isEmailEntered = false; });
                },
                decoration: InputDecoration(
                  labelText: "Email Address",
                  fillColor: off_white,
                  hasFloatingPlaceholder: true,
                  errorText: _inputIsValid ? null : 'Please enter valid email address',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: off_white, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  focusColor: off_white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                style: TextStyle(fontSize: 20, color: off_white),
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  fillColor: off_white,
                  hasFloatingPlaceholder: true,
                  enabled: _isEmailEntered ? true : false,
                  errorText: _inputIsValid ? null : 'Please enter valid password',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: off_white, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  focusColor: off_white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                splashColor: Theme.of(context).accentColor,
                height: 67.0,
                color: off_white,
                onPressed: (){
                  _onLoginButtonPressed();
                },
//                onPressed: () async {
//                  state is! LoginLoading ? _onLoginButtonPressed() : null;
//                },
                padding: const EdgeInsets.all(18.0),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 25, color: pink, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: _launchUrl,
              child: Text(
                'Forgot Password / Signup?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
//            Padding(
//              padding: const EdgeInsets.symmetric(vertical: 20.0),
//              child: Center(
//                child: state is LoginLoading ? CircularProgressIndicator() : null,
//              ),
//            ),
          ],
        ),
      );
    }

    return kForm();
//    return BlocListener<LoginBloc, LoginState>(
//      listener: (context, state) {
//        if (state is LoginFailure) {
//          Scaffold.of(context).showSnackBar(
//            SnackBar(
//              content: Text('${state.error}'),
//              backgroundColor: Colors.red,
//            ),
//          );
//        }
//      },
//      child: BlocBuilder<LoginBloc, LoginState>(
//        builder: (context, state) {
//          return kForm(state);
//        },
//      ),
//    );
  }

}
