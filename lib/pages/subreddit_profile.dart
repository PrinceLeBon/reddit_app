import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:reddit_app/pages/subreddit_page.dart';
import 'package:reddit_app/widgets/profile_picture.dart';
import 'package:http/http.dart' as http;
import '../components/globals.dart';
import '../models/reddit_post.dart';
import '../widgets/post.dart';

class SubredditProfile extends StatefulWidget {
  final String authToken;
  final String subredditName;

  const SubredditProfile(
      {Key? key, required this.authToken, required this.subredditName})
      : super(key: key);

  @override
  State<SubredditProfile> createState() => _SubredditProfileState();
}

class _SubredditProfileState extends State<SubredditProfile> {
  late String banner_img = '';
  late String profile_img = '';
  late int numberSubscribers = 0;
  late String description = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubredditInfo(widget.authToken, widget.subredditName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0,
            collapsedHeight: 40,
            toolbarHeight: 40,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return SubredditPage(authToken: widget.authToken);
                  }));
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            actions: [
              IconButton(
                  onPressed: () {
                    getSubredditInfo(widget.authToken, widget.subredditName);
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  ))
            ],
            expandedHeight: 285,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    /*decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                banner_img.replaceAll('&amp;', '&')),
                            fit: BoxFit.cover)),*/
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  color: (profile_img.isEmpty)
                                      ? Colors.black
                                      : Colors.white,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: (profile_img.isEmpty)
                                    ? const Text(
                                        '/r',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Colors.white),
                                      )
                                    : Profile_Picture(
                                        taille: 60,
                                        image: profile_img.replaceAll(
                                            '&amp;', '&')),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.subredditName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            TextButton(
                                onPressed: Subscription,
                                child: (SubscribedSubredditOfUser.contains(
                                        widget.subredditName.substring(2)))
                                    ? Text('Subscribed')
                                    : Text('Subscribe'))
                          ],
                        ),
                        Text(
                          '$numberSubscribers members',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(description, style: const TextStyle(fontSize: 12))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.transparent,
            pinned: true,
            leading: Container(),
            collapsedHeight: 5,
            toolbarHeight: 5,
            elevation: 0,
          ),
          (listRedditPost.isEmpty)
              ? const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverAnimatedList(
                  itemBuilder: (_, index, ___) {
                    return Post(
                        redditPost: listRedditPost[index],
                        authToken: widget.authToken);
                  },
                  initialItemCount: listRedditPost.length,
                )
        ],
      ),
    );
  }

  Future<void> getSubredditInfo(String authToken, String subredditName) async {
    http.Response response = await http.get(
      Uri.https('oauth.reddit.com', '$subredditName/about'),
      headers: <String, String>{'Authorization': 'Bearer $authToken'},
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        profile_img = jsonData['data']['community_icon'];
        banner_img = jsonData['data']['banner_background_image'];
        numberSubscribers = jsonData['data']['subscribers'];
        description = jsonData['data']['public_description'];
        getSubredditPosts(authToken, subredditName);
      });
    } else {
      throw Exception('Failed to load subreddit $subredditName infos');
    }
  }

  void getSubredditPosts(String accessToken, String subreddit) async {
    listRedditPost.clear();
    final response = await http.get(
      Uri.https('oauth.reddit.com', '$subreddit/new', {'limit': '100'}),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> postsData = jsonData['data']['children'];
      Map<dynamic, dynamic> v = postsData[6];
      Map<dynamic, dynamic> vv = v['data'];
      vv.forEach((key, value) {
        print('$key : $value');
      });
      print(v);
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
          //listRedditPost.add(redditPost);
        });
      }
    } else {
      throw Exception('Failed to load subreddit $subreddit posts');
    }
  }

  Future<void> Subscription() async {
    final String action;
    if (SubscribedSubredditOfUser.contains(widget.subredditName.substring(2))) {
      action = 'unsub';
      setState(() {
        SubscribedSubredditOfUser.remove(widget.subredditName.substring(2));
        print(SubscribedSubredditOfUser);
      });
    } else {
      action = 'sub';
      setState(() {
        SubscribedSubredditOfUser.add(widget.subredditName.substring(2));
        print(SubscribedSubredditOfUser);
      });
    }
    final response = await http.post(
      Uri.https('oauth.reddit.com', '/api/subscribe'),
      headers: <String, String>{'Authorization': 'Bearer ${widget.authToken}'},
      body: {'sr_name': widget.subredditName.substring(2), 'action': action},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle subscription');
    }
  }
}
