import 'package:flutter/material.dart';
import 'package:news_and_forums/screens/admin_add_news.dart';

class AdminNews extends StatefulWidget {
  const AdminNews({super.key});

  @override
  State<AdminNews> createState() => _AdminNewsState();
}

class _AdminNewsState extends State<AdminNews> {
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
                  padding: EdgeInsets.only(top: 10, left: 28.0, right: 28.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'News List',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 9, 117, 14)),
                        ),
                        SizedBox(height: 5),
                        Card(
                          child: SizedBox(
                            height: 120,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'image/newz.png',
                                    width: 100,
                                  ),
                                  const SizedBox(width: 5),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Heading'),
                                      Text('Contents........'),
                                    ],
                                  )
                                ],
                              ),
                            ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AdminAddNews()));
          },
          child: Icon(Icons.add_to_queue),
        ));
  }
}
