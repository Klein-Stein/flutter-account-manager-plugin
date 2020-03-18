import 'dart:async';

import 'package:flutter/services.dart';

import 'account.dart';

class AccountManager {
  static const MethodChannel _channel = const MethodChannel('accountManager');

  static const String _KeyAccountName = 'account_name';
  static const String _KeyAccountType = 'account_type';
  static const String _KeyPassword = 'password';

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future addAccount(Account account, {String password}) async {
    await _channel.invokeMethod('addAccount', {
      _KeyAccountName: account.name,
      _KeyAccountType: account.accountType,
      _KeyPassword: password
    });
  }

  static Future<List<Account>> getAccounts() async {
    final accounts = await _channel.invokeMapMethod('getAccounts');
    return [];
  }

  static Future removeAccount(Account account) async {
    await _channel.invokeMethod('removeAccount', {
      _KeyAccountName: account.name,
      _KeyAccountType: account.accountType
    });
  }
}
