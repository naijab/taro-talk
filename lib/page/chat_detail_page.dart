import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  static final route = "/chat/detail";

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  ChatDetailPageParams params;
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
    return Container();
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
