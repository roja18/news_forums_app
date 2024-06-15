import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  late String uid;
  late Future<DocumentSnapshot> userDocument;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    userDocument =
        FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Upload image to Firebase Storage
      try {
        var snapshot = await FirebaseStorage.instance
            .ref('profile_images/$uid.jpg')
            .putFile(imageFile);

        // Get the download URL
        var downloadUrl = await snapshot.ref.getDownloadURL();

        // Update user document with the image URL
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profileImageUrl': downloadUrl,
        });

        setState(() {
          imageUrl = downloadUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to upload image'),
        ));
      }
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
            decoration: const BoxDecoration(color: Colors.lightGreen),
            child: const Padding(
              padding: EdgeInsets.only(top: 80.0, left: 22.0),
              child: Text(
                "ATC \nNews & Forum",
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
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 40, left: 28.0, right: 28.0, bottom: 20.0),
                child: SingleChildScrollView(
                  child: FutureBuilder<DocumentSnapshot>(
                    future: userDocument,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(child: Text('User data not found'));
                      }

                      var userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      imageUrl ??= userData['profileImageUrl'];

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _uploadImage,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl!)
                                  : AssetImage('image/atc.png')
                                      as ImageProvider<Object>,
                            ),
                          ),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: _uploadImage,
                            child: Text("Change Profile Image"),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Full Name: ${userData['fullname'] ?? 'N/A'}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Email: ${userData['email'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 8.0),
                          // Add more user fields here as needed
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
            );
          });
        },
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Sign Out"),
            SizedBox(width: 5), // Add some space between the text and the icon
            Icon(Icons.logout),
          ],
        ),
      ),
    );
  }
}
