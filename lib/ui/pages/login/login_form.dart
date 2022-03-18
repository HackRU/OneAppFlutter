import 'package:HackRU/models/cred_manager.dart';
import 'package:HackRU/services/hackru_service.dart';
import 'package:HackRU/styles.dart';
import 'package:HackRU/defaults.dart';
import 'package:HackRU/ui/widgets/dialog/error_dialog.dart';
import 'package:HackRU/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginForm extends StatefulWidget {
  static bool gotCred = false;
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isInputValid = true;
  bool _isLoginPressed = false;
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
  Widget build(BuildContext context) {
    void _launchUrl() async {
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
        builder: (BuildContext context, {barrierDismissible = false}) {
          return ErrorDialog(body: body);
        },
      )) {
      }
    }

    void _onLoginButtonPressed() async {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        var error = 'Error:\n Missing username and/or password!';
        _errorDialog(error);
      } else {
        try {
          setState(() {
            _isLoginPressed = true;
          });
          final cred =
              await login(_emailController.text, _passwordController.text);
          if (cred != null) {
            LoginForm.gotCred = true;
            await persistCredentials(cred.token, cred.email);
            setState(() {
              _isLoginPressed = false;
            });
            Navigator.of(context).pop('Logged in successfully!');
          } else {
            setState(() {
              _isLoginPressed = false;
            });
            ScaffoldMessengerState().clearSnackBars();
            ScaffoldMessengerState().showSnackBar(
              SnackBar(
                content: Text('Error: Incorrect email or password!'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (error) {
          setState(() {
            _isLoginPressed = false;
          });
          ScaffoldMessengerState().clearSnackBars();
          ScaffoldMessengerState().showSnackBar(
            SnackBar(
              content: Text(error.toString()),
            ),
          );
        }
      }
    }

    Widget kForm() {
      var span = <TextSpan>[];

      span.add(TextSpan(
        text: 'HACK',
        style: Theme.of(context).primaryTextTheme.headline2,
      ));
      span.add(TextSpan(
        text: 'RU',
        style: Theme.of(context).accentTextTheme.headline2,
      ));

      return _isLoginPressed
          ? Center(
              child: FancyLoadingIndicator(),
            )
          : Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(25.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 25.0),
                    child: Column(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: span,
                            style: DefaultTextStyle.of(context).style,
                          ),
                        ),
                        Text(
                          kSeasonTitle,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      controller: _emailController,
                      onChanged: (value) {
                        value.isNotEmpty
                            ? setState(() {
                                _isEmailEntered = true;
                              })
                            : setState(() {
                                _isEmailEntered = false;
                              });
                      },
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        fillColor: Theme.of(context).primaryColor,
                        errorText: isInputValid
                            ? null
                            : 'Please enter valid email address',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HackRUColors.charcoal_light, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        focusColor: HackRUColors.charcoal_light,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        fillColor: Theme.of(context).primaryColor,
                        enabled: _isEmailEntered ? true : false,
                        errorText:
                            isInputValid ? null : 'Please enter valid password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HackRUColors.charcoal_light, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        focusColor: HackRUColors.charcoal_light,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40.0, horizontal: 10.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(1.0),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 50.0,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).backgroundColor,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        _onLoginButtonPressed();
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: _launchUrl,
                    child: Text(
                      'Forgot Password / Signup?',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: kForm(),
    );
  }
}
