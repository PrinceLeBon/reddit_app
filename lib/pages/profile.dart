import 'package:flutter/material.dart';
import 'package:reddit_app/components/globals.dart';

class Profile_Page extends StatefulWidget {
  const Profile_Page({Key? key}) : super(key: key);

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                )),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.share,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.menu,
                  ))
            ],
            expandedHeight: 330,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                            image: NetworkImage(global_user.banner_picture
                                .replaceAll('&amp;', '&')),
                            fit: BoxFit.contain)),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                          image: NetworkImage(global_user
                                              .profile_picture
                                              .replaceAll('&amp;', '&')),
                                          fit: BoxFit.contain)))),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            global_user.username.substring(2),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Row(
                            children: [
                              Text(
                                  '${global_user.username.replaceAll('_', '/')} * ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              /*Text('139 632 karma * ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Text('janv. 14, 2011 ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),*/
                            ],
                          ),
                          Text(global_user.description)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
          )
        ],
      ),
    );
  }
}
