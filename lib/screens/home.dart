import 'package:flutter/material.dart';

import 'component/drawer.dart';
import 'home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: const MyDrawer(),
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                const SliverAppBar(
                  backgroundColor: Colors.lightGreen,
                  title: Text(
                    'ATC NEWS AND FORUM',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        // icon: Icon(Icons.newspaper),
                        text: "News",
                      ),
                      Tab(
                        // icon: Icon(Icons.chat),
                        text: "Forums",
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: const TabBarView(
              children: [
                NewsPage(),
                Icon(Icons.directions_transit),
              ],
            ),
          ),
        ),
      );
  }
}