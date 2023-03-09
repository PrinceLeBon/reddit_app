class User {
  late String username;
  late String description;
  late String profile_picture;
  late String banner_picture;

  User({
    required this.username,
    required this.description,
    required this.profile_picture,
    required this.banner_picture,
  });

  static User fromJson(Map<String, dynamic> json) => User(
      username: json["subreddit"]["display_name"],
      description: json["subreddit"]["description"],
      profile_picture: json["subreddit"]["icon_img"],
      banner_picture: json["subreddit"]["banner_img"]);
}
