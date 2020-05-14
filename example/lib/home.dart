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
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<String> getAccounts() async {
    final accounts = await AccountManager.getAccounts();
    return accounts.toString();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion = 'Not granted';
    final permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission == PermissionStatus.unknown || permission == PermissionStatus.denied) {
      final permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      if (permissions[PermissionGroup.contacts] == PermissionStatus.granted) {
        platformVersion = await getAccounts();
      }
    } else if (permission == PermissionStatus.granted) {
      platformVersion = await getAccounts();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    final account = Account('Denis Sologub', 'com.contedevel.account');
    final result = await AccountManager.addAccount(account);
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