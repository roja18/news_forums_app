import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_and_forums/screens/login.dart';
import '../home_page.dart';
import '../soateco_forum_post.dart';
import '../soateco_news.dart';
import '../soateco_profile.dart';

class SoatecoDrawer extends StatelessWidget {
  const SoatecoDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('image/atc.png'), fit: BoxFit.cover),
            ),
            child: null,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('News'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SoatecoNews()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.forum),
            title: const Text('Forum Post'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SoatecoFormPost()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SoatecoProfile()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
