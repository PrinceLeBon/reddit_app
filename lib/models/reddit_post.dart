class Reddit_Post {
  late String title;
  late String selftext;
  late String author;
  late String url;
  late String subredditName;
  late int numComment;
  late int score;
  late bool isVideo;

  Reddit_Post({
    required this.title,
    required this.selftext,
    required this.author,
    required this.url,
    required this.subredditName,
    required this.numComment,
    required this.score,
    required this.isVideo,
  });
}
