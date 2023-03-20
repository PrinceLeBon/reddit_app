import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/pages/homepage.dart';
import 'package:reddit_app/pages/profile.dart';
import '../components/globals.dart';
import 'package:http/http.dart' as http;

class CustomDrawer extends StatefulWidget {
  final String authToken;

  const CustomDrawer({Key? key, required this.authToken}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        margin: MediaQuery.of(context).padding,
        child: Padding(
          padding: const EdgeInsets.only(right: 30, left: 20, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                              image: NetworkImage(global_user.profile_picture
                                  .replaceAll('&amp;', '&')),
                              fit: BoxFit.contain)))),
              Container(
                height: 20,
              ),
              Text(
                global_user.username,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
              Container(
                height: 10,
              ),
              InkWell(
                child: _childDrawer1(Icons.person_outlined, 'Profile', 18),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const Profile_Page();
                  }));
                },
              ),
              Container(
                height: 20,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
              ),
              Container(
                height: 30,
              ),
              InkWell(
                onTap: LogOut,
                child: _childDrawer1(Icons.logout, 'Log Out', 18),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _childDrawer1(IconData icon, String label, double _size) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        Container(
          width: 10,
        ),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _size,
          ),
        ),
      ],
    );
  }

  Future<void> LogOut() async {
    final response = await http.post(
        Uri.https('www.reddit.com', '/api/v1/revoke_token'),
        headers: <String, String>{
          'Authorization': 'Basic : ${widget.authToken}'
        },
        body: {
          'token': widget.authToken,
          'token_type_hint': 'access_token'
        });

    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const MyHomePage();
      }));
    } else {
      if (kDebugMode) {
        print(response.statusCode.toString());
        print(response.reasonPhrase);
        print(widget.authToken);
      }
      throw Exception('Failed to log out');
    }
  }
}
