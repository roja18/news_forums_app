import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'component/soateco_drawer.dart';

class SoatecoProfile extends StatefulWidget {
  const SoatecoProfile({Key? key});

  @override
  State<SoatecoProfile> createState() => _SoatecoProfileState();
}

class _SoatecoProfileState extends State<SoatecoProfile> {
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
      appBar: AppBar(
        title: Text('ATC News & Forum App'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<DocumentSnapshot>(
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

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          imageUrl ??= userData['profileImageUrl'];

          return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                ),
              ),
            ),
          );
        },
      ),
      drawer: SoatecoDrawer(),
    );
  }
}
