import 'package:flutter/material.dart';
import 'package:taro_talk/app_config.dart';

import 'login_otp_page.dart';

class LoginPage extends StatefulWidget {
  static final route = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  AppConfig.logoIcon,
                ),
                SizedBox(
                  height: 120,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(60),
        child: RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, LoginOTPPage.route);
          },
          color: Colors.black.withAlpha(7),
          child: Text(
            "ดำเนินการต่อด้วยเบอร์โทรศัพท์",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
