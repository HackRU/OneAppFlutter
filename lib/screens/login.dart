import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/main.dart';
import 'package:HackRU/screens/signup.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _inputIsValid = true;

  @override
  Widget build(BuildContext context) {
    String email, password;
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
                    child: Text('SIGN UP'),
                    textColor: bluegrey,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                    onPressed: (){
                      _usernameController.clear();
                      _passwordController.clear();
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
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
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Main()),
                    );
                  },
                ),
              ],
            ),
            RaisedButton(
              child: Text('TEST LCS'),
              color: pink_dark,
              textColor: white,
              textTheme: ButtonTextTheme.normal,
              elevation: 6.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
              onPressed: (){this.postData();},
            ),
          ],
        ),
      ),
    );
  }

  var client = new http.Client();
  var url = "https://7c5l6v7ip3.execute-api.us-west-2.amazonaws.com/lcs-test/authorize";
  postData() async {
    var response = await client.post(url, body: {"email": "f@f.com", "password": "f"});
    print("Response Status: ${response.statusCode}");
    print("Response body: ${response.body}");
//    client.close();
  }

}
