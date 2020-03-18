import 'package:flutter/material.dart';
import 'dart:async';

import 'package:accountmanager/accountmanager.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
