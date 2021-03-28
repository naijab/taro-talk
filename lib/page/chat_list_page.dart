import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taro_talk/app_config.dart';
import 'package:taro_talk/page/contact_list_page.dart';

class ChatListPage extends StatefulWidget {
  static final route = "/chat/list";

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final chatRef =
      FirebaseFirestore.instance.collection(AppConfig.ChatCollection);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          AppConfig.logoWithText,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, ContactListPage.route);
            },
          )
        ],
      ),
      body: Center(
        child: Text("Empty Chat"),
      ),
    );
  }
}
