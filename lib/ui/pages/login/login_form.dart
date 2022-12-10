import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/models/exceptions.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/defaults.dart';
import 'package:hackru/ui/hackru_app.dart';
import 'package:hackru/ui/pages/home.dart';
import 'package:hackru/ui/widgets/dialog/error_dialog.dart';
import 'package:hackru/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/models.dart';

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
  final TextEditingController _textFieldController = TextEditingController();
  bool isInputValid = true;
  bool _isLoginPressed = false;
  var _isEmailEntered = false;
  static var credStr = '';
  static var guestUser;
  CredManager? credManager;

  @override
  void initState() {
    credManager = Provider.of<CredManager>(context, listen: false);
    super.initState();
  }

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
        debugPrint("====== LOGIN_FORM_VALIDATION_ERROR: $error");
        _errorDialog(error);
      } else {
        try {
          setState(() {
            _isLoginPressed = true;
          });
          final cred =
              await login(_emailController.text, _passwordController.text);
          User userData = await getUser(cred.token, _emailController.text);
          if (cred.token != null) {
            LoginForm.gotCred = true;
            credManager!.persistCredentials(cred.token, userData.email);
            setState(() {
              _isLoginPressed = false;
            });
            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    Provider.value(value: credManager, child: HackRUApp()),
                maintainState: false,
              ),
              ModalRoute.withName('/main'),
            );
            // Navigator.of(context, rootNavigator: false)
            //     .pop('Logged in successfully!');
          } else {
            setState(() {
              _isLoginPressed = false;
            });
            ScaffoldMessengerState().clearSnackBars();
            ScaffoldMessengerState().showSnackBar(
              const SnackBar(
                content: Text('Error: Incorrect email or password!'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } on LcsLoginFailed {
          setState(() {
            _isLoginPressed = false;
          });
          var error = 'Error:\n Login failed!';
          _errorDialog(error);
        } catch (error) {
          setState(() {
            _isLoginPressed = false;
          });
          var _error = error.toString();
          _errorDialog(_error);
          ScaffoldMessengerState().clearSnackBars();
          ScaffoldMessengerState().showSnackBar(
            SnackBar(
              content: Text(error.toString()),
            ),
          );
        }
      }
    }

    String? valueText;
    String? codeDialog;
    Future _displayTextInputDialog(BuildContext context) async {
      codeDialog = '';
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              backgroundColor: HackRUColors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: const Text('Enter valid email for password reset'),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    valueText = value;
                  });
                },
                controller: _textFieldController,
                decoration:
                    const InputDecoration(hintText: "emailtolink@email.com"),
              ),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(15.0),
                    ),
                  ),
                  child: const Text(
                    'CANCEL',
                    style:
                        TextStyle(fontSize: 20, color: HackRUColors.pink_dark),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  splashColor: HackRUColors.yellow,
                  height: 40.0,
                  color: HackRUColors.off_white,
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
                  onPressed: () {
                    setState(() {
                      codeDialog = valueText;
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
    }

    void _scanDialogSuccess(String body) async {
      switch (await showDialog(
        context: context,
        builder: (BuildContext context, {barrierDismissible = false}) {
          return AlertDialog(
            backgroundColor: HackRUColors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: const Icon(
              Icons.check_circle_outline,
              color: HackRUColors.off_white,
              size: 80.0,
            ),
            content: Text(body,
                style: const TextStyle(
                    fontSize: 25, color: HackRUColors.off_white),
                textAlign: TextAlign.center),
            actions: <Widget>[
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                splashColor: HackRUColors.yellow,
                height: 40.0,
                color: HackRUColors.off_white,
                onPressed: () {
                  Navigator.pop(context, true);
                },
                padding: const EdgeInsets.all(15.0),
                child: const Text(
                  'OK',
                  style: TextStyle(
                      fontSize: 20,
                      color: HackRUColors.pink,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      )) {
      }
    }

    Future _scanDialogWarning(String body) async {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context, {barrierDismissible = false}) {
          return AlertDialog(
            backgroundColor: HackRUColors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: const Icon(
              Icons.warning,
              color: HackRUColors.off_white,
              size: 80.0,
            ),
            content: Text(body,
                style: const TextStyle(
                    fontSize: 25, color: HackRUColors.off_white),
                textAlign: TextAlign.center),
            actions: <Widget>[
              // TextButton(
              //   style: ButtonStyle(
              //     padding: MaterialStateProperty.all(
              //       const EdgeInsets.all(15.0),
              //     ),
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context, false);
              //   },
              //   child: const Text(
              //     'CANCEL',
              //     style: TextStyle(fontSize: 20, color: HackRUColors.pink_dark),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
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

    void handleForgotPassword() async {
      codeDialog = "";
      await _displayTextInputDialog(context);
      if (codeDialog != "") {
        try {
          debugPrint(codeDialog);
          var res = await forgotPassword(codeDialog!);
          if (res == 200) {
            var result = "A link has been sent to your email.";
            _scanDialogSuccess(result);
          }
        } on LcsError {
          var result = "Invalid email.";
          _scanDialogWarning(result);
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ListView(
                controller: ScrollController(),
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
                        vertical: 30.0, horizontal: 10.0),
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
                    onTap: () {
                      handleForgotPassword();
                    },
                    child: const Text(
                      'Forgot Password?',
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
