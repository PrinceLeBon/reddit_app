import 'package:flutter/material.dart';
import 'package:reddit_app/pages/profile.dart';
import '../components/globals.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    // TODO: implement initState
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
                child: _childDrawer1(Icons.logout, 'Log Out', 18),
                onTap: () {
                  /*FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Login()));*/
                },
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
}
