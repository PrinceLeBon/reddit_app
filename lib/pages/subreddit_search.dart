import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_app/pages/subreddit_profile.dart';

class SubredditSearch extends StatefulWidget {
  final String authToken;
  final String subredditName;

  const SubredditSearch(
      {Key? key, required this.subredditName, required this.authToken})
      : super(key: key);

  @override
  State<SubredditSearch> createState() => _SubredditSearchState();
}

class _SubredditSearchState extends State<SubredditSearch> {
  List<dynamic> result = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchSubreddit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
          separatorBuilder: (context, index) {
            return Container(
              color: Colors.grey,
              height: 5,
              width: MediaQuery.of(context).size.width,
            );
          },
          itemCount: result.length,
          cacheExtent: 5,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                result[index].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SubredditProfile(
                      authToken: widget.authToken,
                      subredditName: 'r/${result[index].toString()}');
                }));
              },
            );
          }),
    );
  }

  Future<void> searchSubreddit() async {
    http.Response response = await http.get(
      Uri.https('oauth.reddit.com', '/api/search_reddit_names',
          {'query': widget.subredditName, 'exact': 'false'}),
      headers: <String, String>{'Authorization': 'Bearer ${widget.authToken}'},
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> r = jsonData["names"];
      for (var element in r) {
        setState(() {
          result.add(element);
        });
      }
    } else {
      throw Exception(
          'Failed to load subreddit ${widget.subredditName} search');
    }
  }
}
