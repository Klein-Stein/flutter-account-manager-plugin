import 'package:flutter/material.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

import 'package:accountmanager/account.dart';
import 'package:accountmanager/accountmanager.dart';

import 'login.dart';

class HomeWidget extends StatefulWidget {

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Account _account;

  @override
  void initState() {
    super.initState();
    loadAccount();
  }
  
  Future<Account> findAccount() async {
    var accounts = await AccountManager.getAccounts();
    if (accounts.length > 0) {
      return accounts[0];
    }
    return null;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future loadAccount() async {
    Account account;
    final permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    if (permission == PermissionStatus.unknown || permission == PermissionStatus.denied) {
      final permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      if (permissions[PermissionGroup.contacts] == PermissionStatus.granted) {
        account = await findAccount();
      }
    } else if (permission == PermissionStatus.granted) {
      account = await findAccount();
    }
    if (!mounted) return;
    setState(() {
      _account = account;
    });
  }

  Future signOut() async {
    await AccountManager.removeAccount(_account);
    if (!mounted) return;
    setState(() {
      _account = null;
    });
  }

  navigateToLoginScreen() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginWidget()),
    );
    if (!mounted) return;
    setState(() {
      _account = result;
    });
  }
  
  Widget getContent(BuildContext context) {
        if (_account == null) {
          return Center(
            child: RaisedButton(
              onPressed: () {
                navigateToLoginScreen();
              },
              child: Text('Sign in'),
            ),
          );
        }
        return Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Hello, ' + _account.name + '!'),
              RaisedButton(
                  onPressed: () {
                    signOut();
                  },
                  child: Text('Sign out')
              )
            ],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account manager'),
      ),
      body: getContent(context)
    );
  }
}