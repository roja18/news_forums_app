import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 2.0),
          //   child: Container(
          //     padding: const EdgeInsets.all(15.0),
          //     height: 180,
          //     decoration: BoxDecoration(
          //       image: const DecorationImage(
          //         image: AssetImage('image/top.webp'),
          //         fit: BoxFit.cover, // Set fit to cover the entire container
          //       ),
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(20.0),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.shade200,
          //           offset: const Offset(0, 4),
          //           blurRadius: 10.0,
          //         ),
          //       ],
          //     ),
          //     child: null, // You can remove the child if not needed
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'News and Event',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'View all',
                  style: TextStyle(color: Colors.purple),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                          child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('image/latest.avif'),
                            fit: BoxFit
                                .cover, // Set fit to cover the entire container
                          ),
                        ),
                        height: 400,
                        width: 300,
                      )),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            height: 400,
                            width: 300,
                            child: Image.asset('image/news.png')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Forums',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'View all',
                  style: TextStyle(color: Colors.purple),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                          child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('image/forum.jpg'),
                            fit: BoxFit
                                .cover, // Set fit to cover the entire container
                          ),
                        ),
                        height: 400,
                        width: 300,
                      )),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // ListTile(
                      //   trailing: ,
                      // )
                      Card(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            height: 400,
                            width: 300,
                            child: Image.asset('image/forum2.jpg')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
