import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_and_forums/screens/admin_home.dart';
import 'package:news_and_forums/screens/home.dart';
import 'package:news_and_forums/screens/login.dart';

import 'screens/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            User user = snapshot.data!;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasData) {
                  String userType = userSnapshot.data!['usertype'];
                  if (userType == 'User') {
                    return HomeScreen();
                  } else if (userType == 'Admin') {
                    return NewsPage();
                  } else if (userType == 'SupperUser') {
                    return AdminHome();
                  } else {
                    return LoginPage();
                  }
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                } else {
                  return LoginPage();
                }
              },
            );
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
