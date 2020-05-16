import 'dart:convert';

import 'package:http/http.dart';

import 'g.dart';

class AccessToken {
  String accessToken;
  String tokenType;

  AccessToken(this.accessToken, this.tokenType);
}

class User {
  int id;
  String login;
  String name;

  User(this.id, this.login, this.name);
}

class RestApi {
  static const root = 'https://api.github.com';
  var _client = new Client();

  void close() {
    _client.close();
  }

  Future<User> fetchUser(AccessToken token) async {
    var response = await _client.get('https://api.github.com/user',
        headers: {
          'Authorization': token.tokenType + ' ' + token.accessToken,
          'Content-Type': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return new User(result['id'], result['login'], result['name']);
    }
    return null;
  }

  Future<AccessToken> fetchAccessToken(String code) async {
    const url = 'https://github.com/login/oauth/access_token';
    Map data = {
      'client_id': G.client_id,
      'client_secret': G.client_secret,
      'code': code
    };
    //encode Map to JSON
    var body = json.encode(data);
    var response = await _client.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    if (response.statusCode == 200) {
      var uri = Uri.parse('http://www.response.com/result?' + response.body);
      var accessToken = uri.queryParameters['access_token'];
      var tokenType = uri.queryParameters['token_type'];
      return new AccessToken(accessToken, tokenType);
    }
    return null;
  }
}