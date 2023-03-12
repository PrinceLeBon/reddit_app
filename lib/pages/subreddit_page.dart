import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_app/models/reddit_post.dart';
import 'package:reddit_app/pages/subreddit_search.dart';
import 'package:reddit_app/widgets/post.dart';
import '../components/globals.dart';

class SubredditPage extends StatefulWidget {
  final String authToken;

  const SubredditPage({Key? key, required this.authToken}) : super(key: key);

  @override
  State<SubredditPage> createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSubredditPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: Form(
              key: _formKey,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                controller: myController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subreddit name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return SubredditSearch(
                              authToken: widget.authToken,
                              subredditName: myController.text.trim(),
                            );
                          }));
                        }
                      },
                      icon: const Icon(Icons.search, color: Colors.white)),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              )),
          actions: [
            IconButton(
                onPressed: _loadSubredditPosts, icon: const Icon(Icons.cached))
          ],
        ),
        body: (listRedditPost.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 5,
                    width: MediaQuery.of(context).size.width,
                  );
                },
                itemCount: listRedditPost.length,
                cacheExtent: 5,
                itemBuilder: (context, index) {
                  return Post(
                    redditPost: listRedditPost[index],
                    authToken: widget.authToken,
                  );
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
      setState(() {
        SubscribedSubredditOfUser = subredditList;
        print(SubscribedSubredditOfUser);
      });
      return subredditList;
    } else {
      throw Exception('Failed to load subscribed subreddits');
    }
  }

  void getSubredditPosts(String accessToken, String subreddit) async {
    setState(() {
      listRedditPost.clear();
    });
    final response = await http.get(
      Uri.https('oauth.reddit.com', '/r/$subreddit/new', {'limit': '100'}),
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
        setState(() {
          listRedditPost.add(redditPost);
          listRedditPost.shuffle();
        });
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
    listRedditPost.clear();
    List<String> listSubreddit =
        await getSubscribedSubreddits(widget.authToken);
    int i = listSubreddit.indexOf('announcements');
    listSubreddit.removeAt(i);
    for (var subreddit in listSubreddit) {
      getSubredditPosts(widget.authToken, subreddit);
    }
  }
}
