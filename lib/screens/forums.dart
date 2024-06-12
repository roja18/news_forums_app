import 'package:flutter/material.dart';

class ForumSection extends StatelessWidget {
  const ForumSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5, // Replace with the actual number of forum posts
        (index) => ForumCard(),
      ),
    );
  }
}

class ForumCard extends StatelessWidget {
  const ForumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Colors.green),
                  SizedBox(width: 7),
                  Text(
                    'Admission Number',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'Date & Time',
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
              SizedBox(height: 4.0),
              Text(
                'Content of the forum post goes here.',
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(image: AssetImage('image/atc.png')),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.mark_as_unread)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.message)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
