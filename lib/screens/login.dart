import 'package:HackRU/loading_indicator.dart';
import 'package:HackRU/screens/home.dart';
import 'package:HackRU/screens/scanner2.dart';
import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/main.dart';
import 'package:HackRU/filestore.dart';
import 'package:dart_lcs_client/dart_lcs_client.dart';
import 'package:HackRU/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  //const Login({Key: key}): super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _inputIsValid = true;
  static var credStr = '';
  static LcsCredential credential;

  final formKey = new GlobalKey<FormState>();

  checkFields(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  _launchUrl() async {
    const url = 'https://dev.hackru.org/signup';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  initState() {
    // if we have a stored credential then login with that
    super.initState();
    getStoredCredential().then((cred) {
        credStr = cred.toString();
        credential = cred;
        print("init got cred"+cred.toString());
        if (cred != null) {
          if (!cred.isExpired()) {
            _loginLoad(context);
            _completeLogin(cred, context);
          } else {
            deleteStoredCredential();
          }
        }
    });
  }

  void _completeLogin(LcsCredential cred, BuildContext context) async {
    // Pop the loading indicator
    Navigator.pop(context);
    QRScanner2.cred = cred;
    Home.userEmail = _emailController.text;
    QRScanner2.userEmail = _emailController.text;
    QRScanner2.userPassword = _passwordController.text;
    Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute( builder: (BuildContext context) => MyHomePage()), ModalRoute.withName('/main'));
//    if(user.role["director"] == true ){
//      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()),);
//      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute( builder: (BuildContext context) => AdminPage()), ModalRoute.withName('/main'));
//    }
//    else{
//      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()),);
//      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute( builder: (BuildContext context) => MyHomePage()), ModalRoute.withName('/main'));
//    }

  }
  _loginLoad(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context, {barrierDismissible: false}){
        return new AlertDialog(backgroundColor: Colors.transparent, elevation: 0.0,
          title: Center(
            child: new ColorLoader2(),
          ),
        );
      }
    );
  }

  // given a context return a login button function
  _buttonLogin(context) => () async {
    _loginLoad(context);
    try {
      var cred = await login(_emailController.text, _passwordController.text, DEV_URL);
      setStoredCredential(cred);
      await _completeLogin(cred, context);
    } catch (e) {
      var errorMessage = "No internet";
      if (e is LcsLoginFailed) {
        errorMessage = e.errorMessage();
      } else if (e is LcsError) {
        errorMessage = e.errorMessage();
      }
      // Pop the loading indicator
      Navigator.pop(context);
      showDialog<void>(context: context, barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(backgroundColor: white,
            title: Text("ERROR: \n'"+errorMessage+"'",
              style: TextStyle(fontSize: 16, color: charcoal),),
            actions: <Widget>[
              FlatButton(
                child: Text('OK', style: TextStyle(fontSize: 16, color: green),),
                onPressed: () {Navigator.pop(context, 'Ok');},
              ),
            ],
          );
        },
      );
    }
    _emailController.clear();
    _passwordController.clear();
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: pink,
    body: SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          SizedBox(height: 5.0),
          Column(
            children: <Widget>[
              Image.asset('assets/images/hackru_white_logo.png', width: 200, height: 200,),
              Text('FALL 2019',
                style: TextStyle(color: off_white, fontSize: 25),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Center(
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 20, color: off_white),
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Username',
                fillColor: off_white,
                hasFloatingPlaceholder: true,
                errorText: _inputIsValid ? null : 'Please enter valid email address',
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: off_white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.0),
          Center(
            child: TextField(
              style: TextStyle(fontSize: 20, color: off_white),
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                fillColor: off_white,
                hasFloatingPlaceholder: true,
                errorText: _inputIsValid ? null : 'Please enter valid password',
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: off_white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
          ),
          SizedBox(height: 40.0,),
          RaisedButton(
            onPressed: _buttonLogin(context),
            elevation: 0.0,
            color: pink,
            textColor: pink,
            padding: const EdgeInsets.all(0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                width: double.infinity,
                height: 60.0,
                color: off_white,
                padding: const EdgeInsets.all(18.0),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(fontSize: 20, color: pink, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: 60.0,),
          RaisedButton(
            onPressed: _launchUrl,
            color: pink,
            elevation: 0.0,
            child: Text('Forgot Password? / Sign Up',
              style: TextStyle(fontSize: 15, color: off_white, fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
              textAlign: TextAlign.center,
            ),
          ),
        ]
      )
    )
  );
}


