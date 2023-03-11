import 'package:flutter/material.dart';
import 'package:reddit_app/models/reddit_post.dart';
import 'package:reddit_app/widgets/profile_picture.dart';

class Post extends StatefulWidget {
  final Reddit_Post redditPost;

  const Post({Key? key, required this.redditPost}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Profile_Picture(taille: 20, image: 'image'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'r/${widget.redditPost.subredditName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('u/${widget.redditPost.author}', style: TextStyle(color: Colors.grey),),
                  ],
                )
              ],
            ),
            Text(
              widget.redditPost.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.redditPost.selftext,
            ),
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.redditPost.url),
                      fit: BoxFit.cover)),
            ),
            Row(
              children: [
                Icon(Icons.arrow_upward),
                Text(widget.redditPost.score.toString()),
                Icon(Icons.arrow_downward),
                Icon(Icons.messenger_outline),
                Text('Commenter'),
                Icon(Icons.share),
                Text('Partager'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
