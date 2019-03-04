import 'package:HackRU/admin.dart';
import 'package:HackRU/models.dart';
import 'package:HackRU/screens/home.dart';
import 'package:HackRU/screens/scanner2.dart';
import 'package:HackRU/test.dart';
import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/main.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:HackRU/hackru_service.dart';
import 'package:HackRU/filestore.dart';

class Login extends StatefulWidget {
  //const Login({Key: key}): super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _inputIsValid = true;

  final formKey = new GlobalKey<FormState>();

  checkFields(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  @override
  initState() {
    // if we have a stored credential then login with that
    super.initState();
    getStoredCredential().then((cred) {
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
    var user = await getUser(cred);
    QRScanner2.cred = cred;
    Home.userEmail = _emailController.text;
    QRScanner2.userEmail = _emailController.text;
    QRScanner2.userPassword = _passwordController.text;
    if(user.role["director"] == true ){
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()),);
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()),);
    }
  }
  _loginLoad(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context, {barrierDismissible: false}){
        return new AlertDialog(backgroundColor: bluegrey_dark,
          title: Center(
            child: new CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(mintgreen_light), strokeWidth: 3.0,),
          ),
        );
      }
    );
  }

  // given a context return a login button functiona
  _buttonLogin(context) => () async {
    _loginLoad(context);
    try {
      var cred = await login(_emailController.text, _passwordController.text);
      setStoredCredential(cred);
      await _completeLogin(cred, context);
    } on LcsLoginFailed catch (e) {
      showDialog<void>(context: context, barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(backgroundColor: bluegrey_dark,
            title: Text("ERROR: \n'"+LcsLoginFailed().toString()+"'",
              style: TextStyle(fontSize: 16, color: pink_light),),
            actions: <Widget>[
              FlatButton(
                child: Text('OK', style: TextStyle(fontSize: 16, color: mintgreen_dark),),
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
    body: SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          SizedBox(height: 30.0),
          Column(
            children: <Widget>[
              Image.asset('assets/images/hackru_circle_logo.png', width: 150, height: 150,),
              SizedBox(height: 5.0),
              Text('SPRING 2019',
                style: TextStyle(color: green_tab, fontSize: 25),
              ),
            ],
          ),
          SizedBox(height: 35.0),
          Center(
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 20, color: bluegrey),
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Username',
                fillColor: bluegrey,
                hasFloatingPlaceholder: true,
                errorText: _inputIsValid ? null : 'Please enter valid email address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.0),
          Center(
            child: TextField(
              style: TextStyle(fontSize: 20, color: bluegrey),
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                fillColor: bluegrey,
                hasFloatingPlaceholder: true,
                errorText: _inputIsValid ? null : 'Please enter valid password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Text('LOGIN'),
                color: pink_dark,
                textColor: white,
                textTheme: ButtonTextTheme.normal,
                elevation: 6.0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                onPressed: _buttonLogin(context),
              ),
            ],
          ),
          SizedBox(height: 60.0,),
        ]
      )
    )
  );
}
