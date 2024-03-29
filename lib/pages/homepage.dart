import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_app/components/globals.dart';
import 'package:reddit_app/models/user.dart';
import 'dart:convert';
import 'package:reddit_app/pages/subreddit_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String _clientId = 'c6sv0jiJ2zDFuH2yWpLk1Q';
  static const String _redirectUri = 'redditapp://oauth2callback';
  static const String _authEndpoint =
      'https://www.reddit.com/api/v1/authorize.compact?';
  static const String _tokenEndpoint =
      'https://www.reddit.com/api/v1/access_token';
  String token = "";

  @override
  Widget build(BuildContext context) {
    return (global_user.username.isEmpty)
        ? Scaffold(
            body: Center(
            child: TextButton(
                onPressed: Connexion, child: const Text('Connexion')),
          ))
        : SubredditPage(authToken: token);
  }

  void Connexion() async {
    String? access = await _getAuthorizationCode();
    setState(() {
      _getAccessToken(access);
    });
  }

  Future<String?> _getAuthorizationCode() async {
    const authorizationUrl = '$_authEndpoint'
        'client_id=$_clientId'
        '&response_type=code'
        '&state=RANDOM_STRING'
        '&redirect_uri=$_redirectUri'
        '&duration=permanent'
        '&scope=identity,edit,flair,history,livemanage,modconfig,modflair,'
        'modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,'
        'structuredstyles,submit,subscribe,vote,wikiedit,wikiread';
    final result = await FlutterWebAuth2.authenticate(
        url: authorizationUrl, callbackUrlScheme: "redditapp");
    final uri = Uri.parse(result);
    final queryParams = uri.queryParameters;
    return queryParams['code'];
  }

  Future<String> _getAccessToken(String? authorizationCode) async {
    final tokenResponse = await http.post(Uri.parse(_tokenEndpoint), headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode("$_clientId:"))}'
    }, body: {
      'grant_type': 'authorization_code',
      'code': authorizationCode,
      'redirect_uri': _redirectUri
    });
    if (tokenResponse.statusCode == 200) {
      final tokenJson = jsonDecode(tokenResponse.body);
      setState(() {
        token = tokenJson['access_token'];
        getuserInfo(token);
      });
    } else {
      throw Exception('Failed to fetch data');
    }
    return token;
  }

  void getuserInfo(String? authToken) async {
    var response = await http.get(
      Uri.https('oauth.reddit.com', '/api/v1/me'),
      headers: <String, String>{'Authorization': 'Bearer $authToken'},
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      setState(() {
        global_user = User(
            username: json["subreddit"]["display_name"],
            description: json["subreddit"]["description"],
            profile_picture: json["subreddit"]["icon_img"],
            banner_picture: json["subreddit"]["banner_img"]);
      });
    } else {
      throw Exception('Failed to get profile data');
    }
  }
}
