import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_and_forums/screens/admin_home.dart';
import 'package:news_and_forums/screens/regster.dart';

import 'component/reusable_widget.dart';
import 'home.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  // signIn() {}
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.lightGreen),
          child: const Padding(
            padding: EdgeInsets.only(top: 100.0, left: 22.0),
            child: Text(
              "Hi..\nWelcome to ATC News & Forum",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white70,
            ),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 28.0, right: 28.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ReusableTextField(text: "Enter Email Address", icon: Icons.mail, isPasswordType: false, controller: _emailController),
                    const SizedBox(height: 15),
                    ReusableTextField(text: "Enter Password", icon: Icons.lock, isPasswordType: true, controller: _passwordController),
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forget Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 4, 73, 7)),
                      ),
                    ),
                    signInSignoutbutton(context, true, () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return Center(child: CircularProgressIndicator());
                        },
                      );
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text)
                          .then((value) async {
                        // Fetch the user type from Firestore
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          DocumentSnapshot userDoc = await FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(user.uid)
                              .get();
                          String userType = userDoc['usertype'];

                          Navigator.pop(context); // Close the progress dialog

                          // Navigate to the appropriate page based on user type
                          if (userType == 'User') {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          } else if (userType == 'Admin') {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsPage()));
                          } else if (userType == 'SupperUser') {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminHome()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Unknown user type'),
                              ),
                            );
                          }
                        }
                      }).onError((error, stackTrace) {
                        Navigator.pop(context); // Close the progress dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            content: Container(
                              padding: const EdgeInsets.all(16),
                              height: 90,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 219, 30, 17),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Error",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text("Error ${error.toString()}"),
                                  ]),
                            ),
                          ),
                        );
                      });
                    }),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'I don\'t have an Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 9, 117, 14)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()));
                            },
                            child: const Text(
                              ' Register',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 2, 29, 3)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
