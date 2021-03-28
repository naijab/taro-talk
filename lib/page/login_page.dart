import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taro_talk/app_config.dart';

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
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                child: Image.asset(
                  AppConfig.logoIcon,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  // TODO Open OTP Page
                },
                color: Colors.black.withAlpha(7),
                child: Text(
                  "ดำเนินการต่อด้วยเบอร์โทรศัพท์",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
