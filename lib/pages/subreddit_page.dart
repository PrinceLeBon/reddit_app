import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_app/models/reddit_post.dart';
import 'package:reddit_app/widgets/post.dart';

import '../components/globals.dart';

class SubredditPage extends StatefulWidget {
  final String authToken;

  const SubredditPage({Key? key, required this.authToken}) : super(key: key);

  @override
  State<SubredditPage> createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSubredditPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white60,
        appBar: AppBar(),
        body: ListView.builder(
            itemCount: listRedditPost.length,
            cacheExtent: 5,
            itemBuilder: (context, index) {
              return Post(redditPost: listRedditPost[index]);
            }));
  }

  Future<List<String>> getSubscribedSubreddits(String accessToken) async {
    final response = await http.get(
      Uri.https('oauth.reddit.com', '/subreddits/mine/subscriber'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<dynamic> tab = json['data']['children'];
      final List<String> subredditList = tab
          .map((subreddit) => subreddit['data']['display_name'])
          .toList()
          .cast<String>();
      return subredditList;
    } else {
      throw Exception('Failed to load subscribed subreddits');
    }
  }

  /*Future<List<Reddit_Post>>*/
  void getSubredditPosts(String accessToken, String subreddit) async {
    final response = await http.get(
      Uri.https('oauth.reddit.com', '/r/$subreddit', {'limit': '100'}),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> postsData = jsonData['data']['children'];
      for (var element in postsData) {
        Reddit_Post redditPost = Reddit_Post(
            title: element['data']['title'],
            selftext: element['data']['selftext'],
            author: element['data']['author'],
            url: element['data']['url'],
            subredditName: element['data']['subreddit_name_prefixed'],
            numComment: element['data']['num_comments'],
            score: element['data']['score'],
            isVideo: element['data']['is_video']);
        listRedditPost.add(redditPost);
      }
      /*Map <dynamic, dynamic> ll = l[9]['data'];
      print('${ll.length} \n\n');
      List <dynamic> lll = ll.keys.toList();
      print(' ${lll.length} \n\n');
      for (int i=0; i<ll.length; i++){
        print('$i: ${lll[i]}: ${ll[lll[i]]} \n');
      }*/

      /*for (int i = 0; i < l.length; i++) {
        print(l[i]['data']['is_video']);
        print('${'author: ' + l[i]['data']['author']}\n');
        print(
            '${'subreddit_name_prefixed: ' +
                l[i]['data']['subreddit_name_prefixed']}\n');
        print('${'url: ' + l[i]['data']['url']}\n');
        print('\n\n\n\n\n\n');
      }*/
      /*final posts = postsData.map((post) {
        final postData = post['data'];
        return RedditPost(
          title: postData['title'],
          author: postData['author'],
          subreddit: postData['subreddit_name_prefixed'],
          thumbnailUrl: postData['thumbnail'],
        );
      }).toList();
      return posts;*/
    } else {
      throw Exception('Failed to load subreddit posts');
    }
  }

  Future<void> _loadSubredditPosts() async {
    List<String> listSubreddit =
        await getSubscribedSubreddits(widget.authToken);
    for (var subreddit in listSubreddit) {
      getSubredditPosts(widget.authToken, subreddit);
    }
    listRedditPost.shuffle();
    /*Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return SubredditPage(authToken: widget.authToken);
    }));*/
  }
}
