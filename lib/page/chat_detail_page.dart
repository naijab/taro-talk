import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taro_talk/model.dart';

import '../app_config.dart';

class ChatDetailPage extends StatefulWidget {
  static final route = "/chat/detail";

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _db = FirebaseFirestore.instance;
  final _authUser = FirebaseAuth.instance.currentUser;

  final _scrollController = ScrollController();
  final _chatForm = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _messageNode = FocusNode();

  ChatDetailPageParams params;
  DocumentReference _chatRef;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetch());
  }

  _fetch() async {
    setState(() {
      _isLoading = true;
    });

    final input =
        ModalRoute.of(context).settings.arguments as ChatDetailPageParams;

    final doc = FirebaseFirestore.instance
        .collection(
          AppConfig.ChatCollection,
        )
        .doc("${input.mobilePhone}");

    final checkIsExist = await doc.get();
    _chatRef = _db
        .collection(
          AppConfig.ChatCollection,
        )
        .doc("${input.mobilePhone}");

    // If not exist create new doc
    if (!checkIsExist.exists) {
      _db
          .collection(
            AppConfig.ChatCollection,
          )
          .doc("${input.mobilePhone}")
          .set(
        {
          "friend_mobile_phone": input.mobilePhone,
          "messages": [],
        },
      );
    }

    setState(() {
      params = input;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "${params != null ? params.name : ""}",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildChat(),
    );
  }

  Widget _buildChat() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: StreamBuilder<DocumentSnapshot>(
            stream: _chatRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatList = Chat.fromJson(snapshot.data.data());
              return ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: chatList.messages.length,
                itemBuilder: (context, index) {
                  final item = chatList.messages[index];
                  final isMe = _authUser.uid == item.from.userId;
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.indigoAccent
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            item.message,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.indigoAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        _buildMessageForm(),
      ],
    );
  }

  Widget _buildMessageForm() {
    return Container(
      height: 60,
      color: Colors.grey.shade300,
      padding: EdgeInsets.all(8.0),
      child: Form(
        key: _chatForm,
        child: TextFormField(
          controller: _messageController,
          focusNode: _messageNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "พิมพ์ข้อความ...",
            filled: true,
            fillColor: Colors.white,
          ),
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.send,
          onFieldSubmitted: (value) async {
            if (value.isNotEmpty) {
              await _sendMessage(value);
            }
          },
        ),
      ),
    );
  }

  _sendMessage(String message) async {
    final doc = await _chatRef.get();
    final messageChat = Chat.fromJson(doc.data());

    final updatedAt = Timestamp.fromDate(
      DateTime.now(),
    );

    messageChat.messages.add(
      ChatMessage(
        message: message,
        from: ChatUser(
          userId: _authUser.uid,
          userName: params.name,
        ),
      ),
    );

    messageChat.updatedAt = updatedAt;

    await _chatRef.update(messageChat.toJson());

    _messageController.clear();

    // Scroll list to bottom
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}

class ChatDetailPageParams {
  final bool isFirstTime;
  final String name;
  final String mobilePhone;

  ChatDetailPageParams(
    this.isFirstTime,
    this.name,
    this.mobilePhone,
  );
}
