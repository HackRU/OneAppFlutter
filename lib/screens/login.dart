import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:HackRU/models.dart';
import 'package:HackRU/test.dart';
import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/main.dart';
import 'package:HackRU/screens/signup.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:HackRU/hackru_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _inputIsValid = true;
  bool _loginSuccess = false;

  final formKey = new GlobalKey<FormState>();
  checkFields(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  loginUser(){
      login(_usernameController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                controller: _usernameController,
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
                OutlineButton(
                    child: Text('CANCEL'),
                    textColor: bluegrey,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                    onPressed: (){
                      _usernameController.clear();
                      _passwordController.clear();
                      Navigator.pop(context, 'Cancel');
                    }),
                RaisedButton(
                  child: Text('LOGIN'),
                  color: pink_dark,
                  textColor: white,
                  textTheme: ButtonTextTheme.normal,
                  elevation: 6.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  ),
                  onPressed: () async {
                    try {
                      await login(_usernameController.text, _passwordController.text);
                      _loginSuccess = true;
                    } on LcsLoginFailed catch (e) {
                      print("LCS Login Failed!");
                    }
                    if (_loginSuccess == true) {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Main()),
                      );
                      _loginSuccess = false;
                    } else {
                      LcsLoginFailed();
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: bluegrey_dark,
                            title: Text("ERROR: \n'"+LcsLoginFailed().toString()+"'",
                                style: TextStyle(fontSize: 16, color: pink_light),),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('OK', style: TextStyle(fontSize: 16, color: mintgreen_dark),),
                                onPressed: () {
                                  Navigator.pop(context, 'Ok');
                                },
                              ),
                            ],
                          );
                        },
                      );
//                      Navigator.push(context,
//                        MaterialPageRoute(builder: (context) => Login()),
//                      );
                    }
                  },
                ),
              ],
            ),
//            RaisedButton(
//              child: Text('TEST LCS'),
//              color: pink_dark,
//              textColor: white,
//              textTheme: ButtonTextTheme.normal,
//              elevation: 6.0,
//              shape: BeveledRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(3.0)),
//              ),
//              onPressed: (){this.postData();},
//            ),
          ],
        ),
      ),
    );
  }

//  var client = new http.Client();
//  var url = "https://7c5l6v7ip3.execute-api.us-west-2.amazonaws.com/lcs-test/authorize";
//  postData() async {
//    Map map = {
//      'email': 'f@f.com', 'password': 'f',
//    };
//    print(await apiRequest(url, map));
//  }
//
//  Future<String> apiRequest(String url, Map jsonMap) async {
//    HttpClient httpClient = new HttpClient();
//    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
//    request.headers.set('content-type', 'application/json');
//    request.add(utf8.encode(json.encode(jsonMap)));
//    HttpClientResponse response = await request.close();
//    String reply = await response.transform(utf8.decoder).join();
//    httpClient.close();
//    return reply;
//  }

}
