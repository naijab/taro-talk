import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taro_talk/app_config.dart';
import 'package:taro_talk/page/contact_list_page.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model.dart';
import 'chat_detail_page.dart';

class ChatListPage extends StatefulWidget {
  static final route = "/chat/list";

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final _authUser = FirebaseAuth.instance.currentUser;
  final _chatList =
      FirebaseFirestore.instance.collection(AppConfig.ChatCollection);

  Query _whereCondition;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetch());
  }

  _fetch() async {
    setState(() {
      _isLoading = true;
    });
    Query condition = _chatList.where(
      "my_id",
      isEqualTo: _authUser.uid,
    );
    setState(() {
      _whereCondition = condition;
      _isLoading = false;
    });
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildChatList(),
    );
  }

  Widget _buildChatList() {
    if (_whereCondition == null) {
      return Container();
    }
    return StreamBuilder<QuerySnapshot>(
      stream: _whereCondition.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData && snapshot.data.docs.isEmpty) {
          return Container(
            child: Center(
              child: Text("ไม่มีข้อความ"),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data?.docs != null) {
          return ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: snapshot.data?.docs?.map((DocumentSnapshot document) {
              final chatItem = Chat.fromJson(document.data());
              ChatMessage recentMessage;
              if (chatItem.messages.length > 0) {
                recentMessage = chatItem.messages[chatItem.messages.length - 1];
              }
              if (recentMessage != null) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ChatDetailPage.route,
                        arguments: ChatDetailPageParams(
                          mobilePhone: chatItem.friendMobilePhone,
                          name: chatItem.friendName,
                        ),
                      );
                    },
                    title: Text(chatItem.friendName),
                    subtitle: Text(
                      "${recentMessage.message}",
                      maxLines: 1,
                    ),
                    trailing: Text(
                      "${timeago.format(recentMessage.createdAt.toDate(), locale: 'th_short')}",
                      maxLines: 1,
                    ),
                  ),
                );
              }
              return Container();
            })?.toList(),
          );
        }
        return Container();
      },
    );
  }
}
