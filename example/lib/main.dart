import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:accountmanager/accountmanager.dart';


class HomeWidget extends StatelessWidget {
  static const kAccountType = 'com.contedevel.account';

  Future<String> fetchName() async {
    String name;
    final permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    if (permission == PermissionStatus.unknown || permission == PermissionStatus.denied) {
      final permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      if (permissions[PermissionGroup.contacts] != PermissionStatus.granted) {
        name = null;
      }
    } else if (permission != PermissionStatus.granted) {
      name = null;
    } else {
      var accounts = await AccountManager.getAccounts();
      for (Account account in accounts) {
        if (account.accountType == kAccountType) {
          await AccountManager.removeAccount(account);
        }
      }
      var account = new Account('User 007', kAccountType, '', '', '');
      await AccountManager.addAccount(account);
      accounts = await AccountManager.getAccounts();
      for (Account account in accounts) {
        if (account.accountType == kAccountType) {
          name = account.name;
          break;
        }
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
                  text = snapshot.data;
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
