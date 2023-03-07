import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String _clientId = 'cRySjh0bQCJK5E0B0ViNQw';
  static const String _redirectUri = 'redditapp://oauth2callback';
  static const String _authEndpoint =
      'https://www.reddit.com/api/v1/authorize.compact?';
  static const String _tokenEndpoint =
      'https://www.reddit.com/api/v1/access_token';
  String token = "c";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times: $token',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _incrementCounter() async {
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
        '&duration=temporary'
        '&scope=read';
    final result = await FlutterWebAuth.authenticate(
        url: authorizationUrl, callbackUrlScheme: "redditapp");
    final uri = Uri.parse(result);
    final queryParams = uri.queryParameters;
    print(queryParams['code']);
    return queryParams['code'];
  }

  Future<String> _getAccessToken(String? authorizationCode) async {
    print(authorizationCode);
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
      });
    } else {
      throw Exception('Failed to fetch data');
    }
    return token;
  }
}
