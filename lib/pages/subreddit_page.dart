import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SubredditPage extends StatefulWidget {
  final String authToken;
  const SubredditPage({Key? key, required this.authToken}) : super(key: key);

  @override
  State<SubredditPage> createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  List<Map<String, dynamic>> _subredditPosts = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(onPressed: () {
          getSubscribedSubreddits(widget.authToken);
        }, child: Text('data')),
      ),
    );
  }
/*
  Future<void> _loadSubredditPosts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final List<String> subscribedSubreddits =
      await getSubscribedSubreddits(widget.authToken);
      final List<Map<String, dynamic>> subredditPosts = [];
      for (final subreddit in subscribedSubreddits) {
        final Map<String, dynamic> posts =
        await getSubredditPosts(widget.authToken, subreddit);
        if (posts.isNotEmpty) {
          subredditPosts.addAll(posts['data']['children']
              .map<Map<String, dynamic>>((post) => post['data'])
              .toList());
        }
      }
      setState(() {
        _subredditPosts = subredditPosts;
      });
    } catch (e) {
      // Gestion des erreurs
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }*/

  /*Future<List<String>>*/ void getSubscribedSubreddits(String accessToken) async {
    final response = await http.get(
      Uri.https('oauth.reddit.com', '/subreddits/mine/subscriber'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print(json);
      /*final subredditsData = jsonData['data']['children'];
      final subreddits = subredditsData
          .map((subreddit) => subreddit['data']['display_name_prefixed'])
          .toList()
          .cast<String>();
      return subreddits;*/
    } else {
      throw Exception('Failed to load subscribed subreddits');
    }
  }

/*
  Future<List<RedditPost>> getSubredditPosts(String accessToken, String subreddit) async {
    final response = await http.get(
      Uri.parse('https://oauth.reddit.com/r/$subreddit/new'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'User-Agent': 'myApp/0.0.1',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final postsData = jsonData['data']['children'];
      final posts = postsData.map((post) {
        final postData = post['data'];
        return RedditPost(
          title: postData['title'],
          author: postData['author'],
          subreddit: postData['subreddit_name_prefixed'],
          thumbnailUrl: postData['thumbnail'],
        );
      }).toList();
      return posts;
    } else {
      throw Exception('Failed to load subreddit posts');
    }
  }*/

}
