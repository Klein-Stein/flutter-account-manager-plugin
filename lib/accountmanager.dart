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
    await _channel.invokeMethod('addAccount', {
      _KeyAccountName: account.name,
      _KeyAccountType: account.accountType,
      _KeyPassword: password
    });
  }

  static Future<List<dynamic>> getAccounts() async {
    final result = await _channel.invokeListMethod('getAccounts');
    var accounts = [];
    for (var item in result) {
      accounts.add(new Account(item[_KeyAccountName], item[_KeyAccountType]));
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
