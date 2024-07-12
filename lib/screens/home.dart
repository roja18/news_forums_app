import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'component/drawer.dart';
import 'forums.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ATC News & Forum App'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'News', color: Colors.blue),
              SizedBox(height: 10.0),
              NewsSection(),
              SizedBox(height: 20.0),
              SectionHeader(title: 'Forum Post', color: Colors.green),
              SizedBox(height: 10.0),
              ForumSection(),
            ],
          ),
        ),
      ),
      drawer: const MyDrawer(),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => SoatecoFormPost()));
      //   },
      //   label: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: const [
      //       Text("Post"),
      //       SizedBox(width: 5), // Add some space between the text and the icon
      //       Icon(Icons.post_add),
      //     ],
      //   ),
      // ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const SectionHeader({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class NewsSection extends StatelessWidget {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('news').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No news articles available'));
          }

          var newsDocs = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newsDocs.length,
            itemBuilder: (context, index) {
              var news = newsDocs[index];
              return NewsCard(
                title: news['title'],
                content: news['content'],
                timestamp: news['timestamp'],
              );
            },
          );
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String content;
  final Timestamp timestamp;

  const NewsCard({
    super.key,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              title: title,
              content: content,
              timestamp: timestamp,
            ),
          ),
        );
      },
      child: Container(
        width: 150.0,
        margin: const EdgeInsets.only(right: 16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: AssetImage('image/atc.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final Timestamp timestamp;

  const NewsDetailPage({
    Key? key,
    required this.title,
    required this.content,
    required this.timestamp,
  }) : super(key: key);

  Future<void> _downloadPDF(BuildContext context) async {
    final pdf = pw.Document();

    final imageBytes =
        (await rootBundle.load('image/atc.png')).buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                height: 200.0,
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(16.0),
                  image: pw.DecorationImage(
                    image: pw.MemoryImage(imageBytes),
                    fit: pw.BoxFit.cover,
                  ),
                ),
              ),
              pw.SizedBox(height: 16.0),
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 24.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8.0),
              pw.Text(
                content,
                style: pw.TextStyle(fontSize: 16.0),
              ),
              pw.SizedBox(height: 8.0),
              pw.Text(
                'Published on: ${timestamp.toDate()}',
                style: pw.TextStyle(fontSize: 14.0, color: PdfColors.grey),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: AssetImage('image/atc.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    content,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Published on: ${timestamp.toDate()}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  ElevatedButton(
                    onPressed: () => _downloadPDF(context),
                    child: Text("Download"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
