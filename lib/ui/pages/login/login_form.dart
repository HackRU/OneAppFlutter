import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/models/exceptions.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/defaults.dart';
import 'package:hackru/ui/widgets/dialog/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hackru/ui/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hackru/ui/widgets/dialog/warning_dialog.dart';

import '../../../models/models.dart';

class LoginForm extends StatefulWidget {
  static bool gotCred = false;
  final VoidCallback goToDashboard;
  const LoginForm({Key? key, required this.goToDashboard}) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _emailResetController = TextEditingController();
  bool isInputValid = true;
  bool _isLoginPressed = false;
  var _isEmailEntered = false;
  static var credStr = '';
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
            var userProfile = await getUser(cred.token, userData.email);
            credManager!.persistCredentials(
                cred.token,
                userData.email,
                userProfile.role.director || userProfile.role.organizer
                    ? "TRUE"
                    : "FALSE");
            setState(() {
              _isLoginPressed = false;
            });
            widget.goToDashboard();
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
              backgroundColor: Color(0xff3e8169),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: const Text(
                'Enter valid email for password reset',
                style: TextStyle(color: HackRUColors.pale_yellow),
              ),
              content: TextField(
                style: const TextStyle(color: HackRUColors.pale_yellow),
                onChanged: (value) {
                  setState(() {
                    valueText = value;
                  });
                },
                controller: _emailResetController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: HackRUColors.pale_yellow)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: HackRUColors.pale_yellow)),
                    hintText: "john.smith@email.com",
                    hintStyle: TextStyle(
                        color: HackRUColors.pale_yellow.withAlpha(50))),
              ),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15.0)),
                  ),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                        fontSize: 20, color: HackRUColors.pale_yellow),
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
                  color: Color.fromARGB(255, 19, 61, 53),
                  padding: const EdgeInsets.all(15.0),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 20,
                      color: HackRUColors.pale_yellow,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    if (valueText == null || valueText!.isEmpty) {
                      Navigator.pop(context);
                      _errorDialog("Please enter an email.");
                    }
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(valueText!);

                    if (!emailValid) {
                      Navigator.pop(context);
                      _errorDialog("Invalid email format.");
                    }
                    setState(() {
                      codeDialog = valueText;
                      Navigator.pop(context);
                      valueText = "";
                    });
                  },
                ),
              ],
            );
          });
    }

    void _loadingDialog(String body, Color bgColor, Color titleColor,
        Color progressColor) async {
      switch (await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text(body, style: TextStyle(color: titleColor)),
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                      child: CircularProgressIndicator(
                        color: progressColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      )) {
        
      }
    }

    void _scanDialogSuccess(
        String body, Color bgColor, Color titleColor, Color textColor) async {
      switch (await showDialog(
        context: context,
        builder: (BuildContext context, {barrierDismissible = false}) {
          return AlertDialog(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Icon(
              Icons.check_circle_outline,
              color: titleColor,
              size: 80.0,
            ),
            content: Text(body,
                style: TextStyle(fontSize: 25, color: textColor),
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
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontSize: 20,
                      color: bgColor,
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

    void handleForgotPassword() async {
      codeDialog = "";
      await _displayTextInputDialog(context);
      if (codeDialog != "") {
        try {
          _loadingDialog("Loading", Color(0xff3e8169), HackRUColors.pale_yellow,
              HackRUColors.pale_yellow);
          var res = await forgotPassword(codeDialog!);
          Navigator.pop(context);
          if (res == 200) {
            var result = "A link has been sent to your email.";
            _scanDialogSuccess(
              "A link has been sent to your email.",
              Color(0xff3e8169),
              HackRUColors.white,
              HackRUColors.pale_yellow,
            );
          }
        } on LcsError {
          var result = "Invalid email.";
          warningDialog(context, result, Color(0xff3e8169),
              HackRUColors.pale_yellow, HackRUColors.pale_yellow);
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
                padding: const EdgeInsets.all(25.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 25.0),
                    child: Column(
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: RichText(
                            text: TextSpan(
                              children: span,
                              style: DefaultTextStyle.of(context).style,
                            ),
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
                      style: const TextStyle(
                        fontSize: 20,
                        color: HackRUColors.pale_yellow,
                      ),
                      controller: _emailController,
                      onChanged: (value) {
                        value.isNotEmpty
                            ? setState(() => _isEmailEntered = true)
                            : setState(() => _isEmailEntered = false);
                      },
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        filled: true,
                        fillColor: Colors.black12,
                        labelStyle:
                            const TextStyle(color: HackRUColors.pale_yellow),
                        labelText: 'Email Address',
                        errorText: isInputValid
                            ? null
                            : 'Please enter valid email address',
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        focusColor: HackRUColors.charcoal_light,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 20,
                        color: HackRUColors.blue_grey,
                      ),
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        filled: true,
                        fillColor: Colors.black12,
                        labelStyle:
                            const TextStyle(color: HackRUColors.pale_yellow),
                        labelText: 'Password',
                        errorText:
                            isInputValid ? null : 'Please enter valid password',
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 2.0),
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
                          const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 50.0,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 19, 61, 53),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25,
                          color: HackRUColors.pale_yellow,
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

    return kForm();
  }
}
