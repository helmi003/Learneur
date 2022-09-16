// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: unnecessary_this, prefer_const_constructors, file_names, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learneur/components/appbarsider.dart';
import 'package:learneur/components/drawer.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class Viewers extends StatefulWidget {
  const Viewers({required this.id});
  final String id;
  @override
  _ViewersState createState() => _ViewersState();
}

class _ViewersState extends State<Viewers> {
  String query = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarsider(context),
      drawer: drawer(),
      body: ListView(
        children: [
          Center(
            child: Text("How many Learneurs",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700])),
          ),
          SizedBox(height: 30,),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('courses')
                  .doc(widget.id)
                  .collection("viewrs")
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
                        element['userName']
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                    .isEmpty) {
                  return SizedBox(
                      height: 20,
                      child: Center(child: Text("No viewers found")));
                } else {
                  return Column(
                    children: snapshot.data!.docs.map((document) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.grey[800],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name : ",
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("Email : ",
                                          style:
                                              TextStyle(color: Colors.orange)),
                                    ]),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(document["userName"]),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(document["mail"]),
                                    ]),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }).toList(),
                  );
                }
              }),
        ],
      ),
    );
  }
}
