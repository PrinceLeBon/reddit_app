import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:reddit_app/models/reddit_post.dart';
import 'package:reddit_app/pages/subreddit_profile.dart';
import 'package:video_player/video_player.dart';

class Post extends StatefulWidget {
  final Reddit_Post redditPost;
  final String authToken;

  const Post({Key? key, required this.redditPost, required this.authToken})
      : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(widget.redditPost.url)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _controller.play());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
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
            (widget.redditPost.isVideo)
                ? (_controller.value.isInitialized)
                    ? Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: VideoPlayer(_controller),
                          ),
                          Container(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder(
                                  valueListenable: _controller,
                                  builder:
                                      (context, VideoPlayerValue value, child) {
                                    return Text(
                                      VideoDuration(value.position),
                                    );
                                  }),
                              Container(width: 10),
                              Expanded(
                                  child: VideoProgressIndicator(_controller,
                                      allowScrubbing: true)),
                              Container(width: 10),
                              Text(
                                VideoDuration(_controller.value.duration),
                              )
                            ],
                          ),
                          IconButton(
                              onPressed: () => _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play(),
                              icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 40))
                        ],
                      )
                    : const Center(child: CircularProgressIndicator())
                : Container(),
            (widget.redditPost.url.contains('youtube'))
                ? InkWell(
                    child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.redditPost.thumbnail
                                    .replaceAll('&amp;', '&')),
                                fit: BoxFit.cover)),
                        child: Center(
                            child: Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: IconButton(
                                      onPressed: () async {
                                        await FlutterWebAuth.authenticate(
                                            url: widget.redditPost.url,
                                            callbackUrlScheme: "redditapp");
                                      },
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                      )),
                                )))),
                    onTap: () async {
                      await FlutterWebAuth.authenticate(
                          url: widget.redditPost.url,
                          callbackUrlScheme: "redditapp");
                    },
                  )
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

  String VideoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
