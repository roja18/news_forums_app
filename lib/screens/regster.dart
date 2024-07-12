import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_and_forums/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'component/reusable_widget.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullnameController.dispose();
    _registrationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Send additional user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'fullname': _fullnameController.text,
        'registration': _registrationController.text,
        'email': _emailController.text.trim(),
        'usertype': 'User',
      });

      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
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
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Error",
                  style: TextStyle(fontSize: 18),
                ),
                Text("Error: ${error.message}"),
              ],
            ),
          ),
        ),
      );
    } catch (error) {
      Navigator.of(context).pop();
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
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Error",
                  style: TextStyle(fontSize: 18),
                ),
                Text("Error: ${error.toString()}"),
              ],
            ),
          ),
        ),
      );
      print("Error: ${error.toString()}");
    }
  }

  @override
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
                  fontWeight: FontWeight.bold,
                ),
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
                  padding:
                      const EdgeInsets.only(top: 25.0, left: 28.0, right: 28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableTextField(text: "Enter FullName", icon: Icons.person, isPasswordType: false, controller: _fullnameController),
                      const SizedBox(height: 15),
                      ReusableTextField(text: "Enter Registration Number", icon: Icons.perm_identity_rounded, isPasswordType: false, controller: _registrationController),
                      const SizedBox(height: 15),
                      ReusableTextField(text: "Enter Email Address", icon: Icons.mail, isPasswordType: false, controller: _emailController),
                      const SizedBox(height: 15),
                      ReusableTextField(text: "Enter Password", icon: Icons.lock, isPasswordType: true, controller: _passwordController),
                      const SizedBox(height: 15),
                      signInSignoutbutton(context, false, () {
                        signUp();
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
                                color: Color.fromARGB(255, 9, 117, 14),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                ' Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 2, 29, 3),
                                ),
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
      ),
    );
  }
}
