import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  static final route = "/chat/detail";

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Detail -- Display Name"),
      ),
      body: Center(
        child: Text("Chat Detail ..."),
      ),
    );
  }
}
