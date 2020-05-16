import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:accountmanager/account.dart';
import 'package:accountmanager/accountmanager.dart';
import 'dart:async';

import 'g.dart';
import 'rest.dart';

class LoginWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  var _code;
  var _status = 'Saving...';

  Future<void> save() async {
    var api = new RestApi();
    try {
      var accessToken = await api.fetchAccessToken(_code);
      if (accessToken != null) {
        var user = await api.fetchUser(accessToken);
        if (user != null) {
          var account = new Account(user.login, 'com.contedevel.account.github');
          await AccountManager.addAccount(account, password: accessToken.accessToken);
          if (!mounted) return;
          setState(() { _status = 'Success!'; });
        } else {
          if (!mounted) return;
          setState(() { _status = 'Failed!'; });
        }
      } else {
        if (!mounted) return;
        setState(() { _status = 'Failed!'; });
      }
    }
    finally {
      api.close();
    }
  }

  Widget getMainWidget(BuildContext context) {
    if (_code == null) {
      return WebView(
        initialUrl: G.auth_url,
        onPageStarted: (String url) {
          if (url.startsWith(G.callback)) {
            setState(() {
              _code = url.replaceFirst(G.callback, '');
            });
            save();
          }
        },
        javascriptMode: JavascriptMode.unrestricted,
      );
    }
    return Center(
        child: Text(_status)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: getMainWidget(context),
    );
  }
}