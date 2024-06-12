import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore library
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; // Import intl library for date formatting
import 'package:news_and_forums/screens/admin_add_news.dart';

class AdminNews extends StatefulWidget {
  const AdminNews({Key? key}) : super(key: key);

  @override
  State<AdminNews> createState() => _AdminNewsState();
}

class _AdminNewsState extends State<AdminNews> {
  void _deleteNews(String docId) {
    FirebaseFirestore.instance.collection('news').doc(docId).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('News deleted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete news: $error')),
      );
    });
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
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0, left: 22.0),
              child: const Text(
                "ATC \nNews & Forum",
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white70,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 10, left: 28.0, right: 28.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'News List',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 9, 117, 14),
                        ),
                      ),
                      SizedBox(height: 5),
                      // Display news articles from Firestore
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('news')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Display loading indicator while fetching data
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          // If data is available, display news articles
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var news = snapshot.data!.docs[index];
                              // Format timestamp to a readable format
                              var timestamp =
                                  (news['timestamp'] as Timestamp).toDate();
                              var formattedDate = DateFormat.yMMMMd()
                                  .add_jm()
                                  .format(timestamp);
                              return Card(
                                child: ListTile(
                                  leading: Image.asset('image/newz.png',
                                      width: 60), // Reduce image size
                                  title: Text(
                                    news['title'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ), // Display news title
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(news[
                                          'content']), // Display news content
                                      SingleChildScrollView(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              formattedDate,
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  _deleteNews(news.id);
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ), // Display formatted date
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminAddNews()));
        },
        child: Icon(Icons.add_to_queue),
      ),
    );
  }
}
