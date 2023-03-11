import 'package:flutter/material.dart';
import 'package:reddit_app/models/reddit_post.dart';
import 'package:reddit_app/pages/subreddit_profile.dart';

class Post extends StatefulWidget {
  final Reddit_Post redditPost;
  final String authToken;

  const Post({Key? key, required this.redditPost, required this.authToken})
      : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //const Profile_Picture(taille: 20, image: 'image'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Text(
                            widget.redditPost.subredditName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return SubredditProfile(
                                  authToken: widget.authToken,
                                  subredditName:
                                      widget.redditPost.subredditName);
                            }));
                          },
                        ),
                        Text(
                          'u/${widget.redditPost.author}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
                Text(
                  widget.redditPost.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              widget.redditPost.selftext,
            ),
            (widget.redditPost.url.contains('.jpg') ||
                    widget.redditPost.url.contains('.png'))
                ? Image.network(widget.redditPost.url)
                : Container(),
            Container(
              height: 10,
            ),
            Row(
              children: [
                const Icon(Icons.arrow_upward),
                Text(widget.redditPost.score.toString()),
                const Icon(Icons.arrow_downward),
                const Icon(Icons.messenger_outline),
                const Text('Comment'),
                const Icon(Icons.share),
                const Text('Share'),
              ],
            )
          ],
        ),
      ),
    );
  }
}