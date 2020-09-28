import 'dart:async';

import 'package:flutter/services.dart';

class Account {
  String name;
  String accountType;
  String authTokenType;
  String accessToken;
  String refreshToken;


  Account(this.name, this.accountType, this.authTokenType,
          this.accessToken, this.refreshToken);
}

class AccountManager {
  static const MethodChannel _channel = const MethodChannel('accountManager');

  static const String _KeyAccountName = 'account_name';
  static const String _KeyAccountType = 'account_type';
  static const String _KeyAuthTokenType = 'auth_token_type';
  static const String _KeyAccessToken = 'access_token';
  static const String _KeyRefreshToken = 'refresh_token';

  static Future<void> addAccount(Account account) async {
    try {
      await _channel.invokeMethod('addAccount', {
        _KeyAccountName: account.name,
        _KeyAccountType: account.accountType,
        _KeyAuthTokenType: account.authTokenType,
        _KeyAccessToken: account.accessToken,
        _KeyRefreshToken: account.refreshToken
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
        accounts.add(new Account(
            item[_KeyAccountName],
            item[_KeyAccountType],
            item[_KeyAuthTokenType],
            item[_KeyAccessToken],
            item[_KeyRefreshToken]
        ));
      }
    } catch(e, s) {
      print(e);
      print(s);
    }
    return accounts;
  }

  static Future<void> removeAccount(Account account) async {
    await _channel.invokeMethod('removeAccount', {
      _KeyAccountName: account.name,
      _KeyAccountType: account.accountType
    });
  }
}
