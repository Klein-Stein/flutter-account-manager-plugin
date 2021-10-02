import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:accountmanager/accountmanager.dart';


class HomeWidget extends StatelessWidget {
  static const kAccountType = 'com.contedevel.account';

  Future<String> fetchName() async {
    String name = '';
    if (await Permission.contacts.request().isGranted) {
      try {
        var accounts = await AccountManager.getAccounts();
        for (Account account in accounts) {
          if (account.accountType == kAccountType) {
            await AccountManager.removeAccount(account);
          }
        }
        var account = new Account(name: 'User 007', accountType: kAccountType);
        if (await AccountManager.addAccount(account)) {
          AccessToken? token = new AccessToken(
              tokenType: 'Bearer',
              token: 'Blah-Blah code'
          );
          await AccountManager.setAccessToken(account, token);
          accounts = await AccountManager.getAccounts();
          for (Account account in accounts) {
            if (account.accountType == kAccountType) {
              token = await AccountManager.getAccessToken(account,
                  token!.tokenType);
              if (token != null) {
                name = account.name + ' - ' + token.token;
              }
              break;
            }
          }
        }
      } catch(e, s) {
        print(e);
        print(s);
      }
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Account manager'),
        ),
        body: Center(
          child: FutureBuilder<String>(
            future: fetchName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              String text = 'Loading...';
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data != null) {
                  text = snapshot.data!;
                } else {
                  text = 'Failed';
                }
              }
              return Text(text);
            },
          ),
        )
    );
  }
}

void main() => runApp(MaterialApp(
  title: 'Account manager',
  home: HomeWidget(),
));
