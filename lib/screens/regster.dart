import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_and_forums/screens/login.dart';

import 'component/reusable_widget.dart';

class Regster extends StatefulWidget {
  const Regster({super.key});

  @override
  State<Regster> createState() => _RegsterState();
}

class _RegsterState extends State<Regster> {
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _regstirationController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Future SignUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    Navigator.of(context).pop();
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
    addUsersDetail(
        _fullnameController.text.trim(),
        int.parse(_regstirationController.text.trim()),
        _emailController.text.trim());
  }

  Future addUsersDetail(String fullname, int admission, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'fullname': fullname,
      'Addmission': admission,
      'email': email,
    });
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _regstirationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.lightGreen),
          child: const Padding(
            padding: EdgeInsets.only(top: 100.0, left: 22.0),
            child: Text(
              "ATC News & Forum",
              style: TextStyle(
                  fontSize: 35,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 25.0, left: 28.0, right: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    reusableTextFild("Enter FullName", Icons.person, false,
                        _fullnameController),
                    const SizedBox(height: 15),
                    reusableTextFild(
                        "Enter Regstration Number",
                        Icons.perm_identity_rounded,
                        false,
                        _regstirationController),
                    const SizedBox(height: 15),
                    reusableTextFild("Enter Email Address", Icons.mail, false,
                        _emailController),
                    const SizedBox(height: 15),
                    reusableTextFild("Enter Password", Icons.mail, true,
                        _passwordController),
                    const SizedBox(height: 15),
                    signInSignoutbutton(context, false, () {
                      SignUp().then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      }).onError((error, stackTrace) {
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
                                    Text(
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
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'I have an Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 9, 117, 14)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: const Text(
                              ' Login',
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
