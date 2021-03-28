import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taro_talk/page/chat_detail_page.dart';
import 'package:taro_talk/page/chat_list_page.dart';
import 'package:taro_talk/page/login_otp_page.dart';
import 'package:taro_talk/page/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Setup Firebase Connection
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Taro Talk",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return LoginPage();
          }
          if (snapshot.hasData) {
            return ChatListPage();
          }
          return Container();
        },
      ),
      routes: {
        LoginPage.route: (context) => LoginPage(),
        LoginOTPPage.route: (context) => LoginOTPPage(),
        ChatListPage.route: (context) => ChatListPage(),
        ChatDetailPage.route: (context) => ChatDetailPage(),
      },
    );
  }
}
