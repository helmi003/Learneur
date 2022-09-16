// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: unnecessary_this, prefer_const_constructors, file_names, deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learneur/components/appbar.dart';
import 'package:learneur/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:learneur/courses.dart/coursedetail.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = "";
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String userName = FirebaseAuth.instance.currentUser!.displayName.toString();
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  late bool permission = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        drawer: drawer(),
        body: Container(
          child: ListView(
            children: [
              SizedBox(height: 10),
              SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CarouselSlider(
                    // ignore: prefer_const_literals_to_create_immutables
                    items: [
                      Image.asset("images/csharp.jpg", fit: BoxFit.cover),
                      Image.asset("images/java.jpg", fit: BoxFit.cover),
                      Image.asset("images/python.jpg", fit: BoxFit.cover),
                      Image.asset("images/reactjs.png", fit: BoxFit.cover),
                    ],
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                  )),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs
                        .where((QueryDocumentSnapshot<Object?> element) =>
                            element['name']
                                .toString()
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .isEmpty) {
                      return SizedBox(
                          height: 20,
                          child: Center(child: Text("No course found")));
                    } else {
                      return Column(
                        children: snapshot.data!.docs.map((document) {
                          return ListTile(
                            leading: Image.asset('images/learneur.png'),
                            title: Text(document['name']),
                            subtitle: Text(
                                "${document['type']} by: ${document['userName']}"),
                            trailing: Icon(Icons.arrow_forward_outlined),
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection("courses")
                                  .doc(document.id)
                                  .collection("viewrs")
                                  .doc(uid)
                                  .set({"userName": userName, "mail": email});
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CourseDetail(data: document)));
                            },
                          );
                        }).toList(),
                      );
                    }
                  }),
            ],
          ),
        ));
  }
}
