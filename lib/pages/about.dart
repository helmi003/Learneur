import 'package:flutter/material.dart';
import 'package:learneur/components/appbar.dart';
import 'package:learneur/components/drawer.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      drawer: drawer(),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text("About",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700])),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
                "Learneur is a platform that allows instructors to build online courses on their preferred topics. Using Learneur's course development tools, they can upload videos, PowerPoint presentations, PDFs, audio, ZIP files and live classes to create courses. Instructors can also engage and interact with users via online discussion boards.",
                style: TextStyle(
                  fontSize: 20,
                )),
          ),
          Center(
            child: Text("Why Learneur?",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700])),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Learn something new! Short courses are an easy, attainable place to start, or expand your knowledge in interesting subjects with a multi-course series. All are from top-ranked universities or industry-leading companies for quality that you can trust.",
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Text("Why learn on Learneur?",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700])),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 400,
            child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: [
                  Card(
                    child: GridTile(
                        child: Icon(
                          Icons.school,
                          size: 50,
                        ),
                        header: Text(
                          'High Quality Education',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        footer: Text(
                          'Courses taught by +140 premier institutions from around the world including Harvard and MIT.',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Card(
                    child: GridTile(
                        child: Icon(
                          Icons.lightbulb,
                          size: 50,
                        ),
                        header: Text(
                          'Career Advancement',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        footer: Text(
                          'Build or enhance skills you need to land your dream job.',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Card(
                    child: GridTile(
                        child: Icon(
                          Icons.public,
                          size: 50,
                        ),
                        header: Text(
                          'Learn Anytime, Anywhere',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        footer: Text(
                          'All you need is wifi, use our web platform or mobile app to complete your course.',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Card(
                    child: GridTile(
                        child: Icon(
                          Icons.menu_book,
                          size: 50,
                        ),
                        header: Text(
                          '+3,500 Courses',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        footer: Text(
                          "Courses in a wide range of subjects and topics, you'll be sure to find the perfect one for you.",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Card(
                    child: GridTile(
                        child: Icon(
                          Icons.schedule,
                          size: 50,
                        ),
                        header: Text(
                          'Self-Paced',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        footer: Text(
                          "No need to complete the same assignments or learn at the same time as others. Learn in your own time",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Card(
                    child: GridTile(
                        child: Icon(
                          Icons.favorite,
                          size: 50,
                        ),
                        header: Text(
                          'Our Promise',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        footer: Text(
                          "We will always guide you and help you whenever you need till you reach your aim",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  )
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text("Who are we at Learneur",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700])),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "At Learneur, we’re working toward an exciting mission, and we care a lot about how we achieve it. Our values guide how we do business—how we interact with each other internally as well as with the millions of instructors, students, and partners that make up our global Learneur community.",
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height:30)
        ],
      ),
      bottomSheet: Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(4, 10, 4, 5),
            child: Text('Copyright © 2021 Learneur . All rights reserved',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ))),
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
      ),
    );
  }
}
