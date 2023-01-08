import 'package:hackru/styles.dart';
import 'package:hackru/ui/pages/login/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback goToDashboard;
  const LoginPage({Key? key, required this.goToDashboard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: HackRUColors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: goToDashboard,
          icon: const Icon(
            Icons.close,
            color: HackRUColors.off_white_blue,
          ),
        ),
      ),
      body: Center(
        child: LoginForm(goToDashboard: goToDashboard),
      ),
    );
  }
}
