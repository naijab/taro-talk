import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taro_talk/app_config.dart';
import 'package:taro_talk/page/chat_detail_page.dart';

class ContactListPage extends StatefulWidget {
  static final route = "/contact/list";

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final chatRef =
      FirebaseFirestore.instance.collection(AppConfig.ChatCollection);

  bool _isLoading = false;

  List<String> _names = [];
  List<String> _phones = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetch());
  }

  _fetch() async {
    setState(() {
      _isLoading = true;
    });

    final permissionStatus = await Permission.contacts.status;
    if (await Permission.contacts.request().isGranted) {
      List<String> names = [];
      List<String> phones = [];

      Iterable<Contact> _contacts =
          await ContactsService.getContacts(withThumbnails: false);

      _contacts.forEach((contact) {
        contact.phones.toSet().forEach((phone) {
          names.add(contact.displayName ?? contact.givenName);
          phones.add(phone.value);
        });
      });

      setState(() {
        _names = names;
        _phones = phones;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("เลือกเพื่อนที่ต้องการแชท"),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildContactList(),
    );
  }

  Widget _buildContactList() {
    if (_names.isEmpty && _phones.isEmpty) {
      return Center(
        child: RaisedButton(
          onPressed: () {
            _fetch();
          },
          child: Text("ไม่พบรายชื่อ ลองอีกครั้ง"),
        ),
      );
    }
    return ListView.builder(
      itemCount: _names != null ? _names.length : 0,
      itemBuilder: (context, index) {
        final name = _names[index];
        final phone = _phones[index];
        return ListTile(
          onTap: () {
            Navigator.pushNamed(
              context,
              ChatDetailPage.route,
              arguments: ChatDetailPageParams(true, name, phone),
            );
          },
          title: Text(name),
        );
      },
    );
  }
}
