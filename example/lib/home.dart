import 'package:flutter/material.dart';
import 'dart:async';

import 'package:accountmanager/account.dart';
import 'package:accountmanager/accountmanager.dart';
import 'package:permission_handler/permission_handler.dart';

import 'login.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    if (permission == PermissionStatus.unknown || permission == PermissionStatus.denied) {
      final permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      if (permissions[PermissionGroup.contacts] == PermissionStatus.granted) {
      }
    } else if (permission == PermissionStatus.granted) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account manager'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginWidget()),
            );
          },
          child: Text('Sign in'),
        ),
      ),
    );
  }
}