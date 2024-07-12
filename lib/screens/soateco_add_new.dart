import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore library
import 'component/reusable_widget.dart';
import 'component/soateco_drawer.dart';
import 'soateco_news.dart';

class SoatecoAddNews extends StatefulWidget {
  const SoatecoAddNews({Key? key}) : super(key: key);

  @override
  State<SoatecoAddNews> createState() => _SoatecoAddNewsState();
}

class _SoatecoAddNewsState extends State<SoatecoAddNews> {
  TextEditingController _newsController = TextEditingController();
  TextEditingController _textEditingController = TextEditingController();

  // Function to add news to Firestore collection
  Future<void> _addNewsToFirestore(String newsTitle, String newsContent) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference newsCollection =
          FirebaseFirestore.instance.collection('news');

      // Add a new document with auto-generated ID
      await newsCollection.add({
        'title': newsTitle,
        'content': newsContent,
        'timestamp': DateTime.now(), // Optional: Include a timestamp
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('News added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SoatecoNews()));
    } catch (error) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add news: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ATC News & Forum App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
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
                  ReusableTextField(
                      text: "Enter News Title",
                      icon: Icons.newspaper,
                      isPasswordType: false,
                      controller: _newsController),
                  const SizedBox(height: 15),
                  ReusableTextareaFild(
                    controller: _textEditingController,
                    hintText: 'Type here news...',
                    icon: Icons.edit,
                    isPasswordType: false,
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      // Extract text from controllers
                      String newsTitle = _newsController.text;
                      String newsContent = _textEditingController.text;

                      // Call function to add news to Firestore
                      _addNewsToFirestore(newsTitle, newsContent);
                    },
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightGreen,
                      ),
                      child: const Center(
                        child: Text(
                          "RELEASE NEWS",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: SoatecoDrawer(),
    );
  }
}
