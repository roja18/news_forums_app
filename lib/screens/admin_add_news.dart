import 'package:flutter/material.dart';

class AdminAddNews extends StatefulWidget {
  const AdminAddNews({super.key});

  @override
  State<AdminAddNews> createState() => _AdminAddNewsState();
}

class _AdminAddNewsState extends State<AdminAddNews> {
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 25.0, left: 28.0, right: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.new_releases,
                            color: Colors.grey,
                          ),
                          label: Text(
                            "News Title",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          )),
                    ),
                    const SizedBox(height: 15),
                    const TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.newspaper,
                            color: Colors.grey,
                          ),
                          label: Text(
                            "News Body",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          )),
                    ),
                    const SizedBox(height: 30),
                    Container(
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
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
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
