import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_app/models/reddit_post.dart';
import 'package:reddit_app/pages/subreddit_search.dart';
import 'package:reddit_app/widgets/custom_drawer.dart';
import 'package:reddit_app/widgets/post.dart';
import 'package:reddit_app/widgets/profile_picture.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        drawer: CustomDrawer(authToken: widget.authToken),
        key: _scaffoldKey,
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
          leading: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Profile_Picture(
                    taille: 20, image: global_user.profile_picture),
              ),
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              }),
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
            url: (element['data']['is_video'])
                ? element['data']['media']['reddit_video']['scrubber_media_url']
                : element['data']['url'],
            subredditName: element['data']['subreddit_name_prefixed'],
            numComment: element['data']['num_comments'],
            score: element['data']['score'],
            isVideo: element['data']['is_video'],
            thumbnail: element['data']['thumbnail'],
            duration: (element['data']['is_video'])
                ? Duration(
                    seconds: element['data']['media']['reddit_video']
                        ['duration'])
                : const Duration(seconds: 0));
        setState(() {
          listRedditPost.add(redditPost);
          listRedditPost.shuffle();
        });
      }
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
