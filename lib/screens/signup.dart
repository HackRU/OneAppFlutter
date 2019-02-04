import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/screens/login.dart';
import 'package:HackRU/main.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();
  bool _inputIsValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          children: <Widget>[
            SizedBox(height: 30.0),
            Column(
              children: <Widget>[
                Image.asset('assets/images/hackru_circle_logo.png', width: 150, height: 150,),
                SizedBox(height: 5.0),
                Text('Spring 2019',
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
                  errorText: _inputIsValid ? null : 'Please enter valid password',
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
                controller: _passwordController2,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Re-enter Password',
                  fillColor: bluegrey,
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
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                    _passwordController2.clear();
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                ),
                RaisedButton(
                  child: Text('SIGN UP'),
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
          ],
        ),
      ),
    );
  }
}
