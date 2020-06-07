import 'dart:async';

import 'package:flutter/services.dart';

class Account {
  String name;
  String accountType;

  Account(this.name, this.accountType);
}

class AccountManager {
  static const MethodChannel _channel = const MethodChannel('accountManager');

  static const String _KeyAccountName = 'account_name';
  static const String _KeyAccountType = 'account_type';
  static const String _KeyPassword = 'password';

  static Future addAccount(Account account, {String password}) async {
    try {
      await _channel.invokeMethod('addAccount', {
        _KeyAccountName: account.name,
        _KeyAccountType: account.accountType,
        _KeyPassword: password
      });
    } catch(e, s) {
      print(e);
      print(s);
    }
  }

  static Future<List<dynamic>> getAccounts() async {
    var accounts = [];
    try {
      final result = await _channel.invokeMethod('getAccounts');
      for (var item in result) {
        accounts.add(new Account(item[_KeyAccountName], item[_KeyAccountType]));
      }
    } catch(e, s) {
      print(e);
      print(s);
    }
    return accounts;
  }

  static Future removeAccount(Account account) async {
    await _channel.invokeMethod('removeAccount', {
      _KeyAccountName: account.name,
      _KeyAccountType: account.accountType
    });
  }
}
