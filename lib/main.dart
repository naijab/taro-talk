import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taro_talk/page/chat_detail_page.dart';
import 'package:taro_talk/page/chat_list_page.dart';
import 'package:taro_talk/page/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Setup Firebase Connection
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Taro Talk",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        LoginPage.route: (context) => LoginPage(),
        ChatListPage.route: (context) => ChatListPage(),
        ChatDetailPage.route: (context) => ChatDetailPage(),
      },
    );
  }
}
