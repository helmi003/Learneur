// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: unnecessary_this, prefer_const_constructors, file_names, deprecated_member_use

// ignore: unused_import
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learneur/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learneur/courses.dart/adding/ModifyCourse.dart';
import '../services/courseDatabase.dart';

// ignore: use_key_in_widget_constructors
class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String query = "";
  int nb = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/appbar.png',
          height: 25,
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "addCourse");
              })
        ],
        elevation: 6,
      ),
      drawer: drawer(),
      body: ListView(
        children: [
          SizedBox(height: 10),
          Center(
            child: Text("Admin Page",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700])),
          ),
          SizedBox(height: 10),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('courses').snapshots(),
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
                      if (document['user'] == uid) {
                        //nb += 1;
                        return ListTile(
                          leading: Image.asset('images/learneur.png'),
                          title: Text(document['name']),
                          subtitle: Text(document['type']),
                          trailing: Icon(Icons.arrow_forward_outlined),
                          onLongPress: () {
                            String imageN = document['imageName'];
                            Alert(document.id, imageN);
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ModifyCourse(
                                        id: document.id, data: document)));
                          },
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  );
                }
              }),
          //nb > 0 ? Container() : Center(child: Text("No course found"))
        ],
      ),
    );
  }

  Alert(String id, String imageN) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text("Do you want to delete this course"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
              TextButton(
                  onPressed: () async {
                    // AsyncSnapshot<QuerySnapshot> snapshot=FirebaseFirestore.instance
                    // .collection("courses")
                    // .doc(id)
                    // .collection("files")
                    // .snapshots() as AsyncSnapshot<QuerySnapshot<Object?>>;
                    // for(int index=0;index>=snapshot.data!.docs.length;index++){
                    //   String filename = snapshot.data!.docs[index]['fileURL'];
                    //   String fileID= snapshot.data!.docs[index].id;
                    //   CourseDatabaseMethods(uid: uid).deleteFile(id,fileID,filename);
                    // }
                    CourseDatabaseMethods(uid: uid).deleteCourse(id, imageN);
                    Navigator.of(context).pop();
                  },
                  child: Text('YES'))
            ],
          );
        });
  }
}
