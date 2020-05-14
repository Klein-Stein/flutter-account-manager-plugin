import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart';
import 'dart:async';

import 'g.dart';

class LoginWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  var _code;

  Future<void> save() async {
    var client = new Client();
    try {
      const url = 'https://github.com/login/oauth/access_token';
      await client.post(url);
    }
    finally {
      client.close();
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
        child: const Text('Saving...')
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