// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learneur/components/appbarsider.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({this.data});
  final QueryDocumentSnapshot<Object?>? data;

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarsider(context),
        body: Container(
          child: ListView(
            children: [
              Image.network(
                widget.data!.get("downloadURL"),
                height: 300,
                fit: BoxFit.fitWidth,
              ),
              Center(
                child: Text(widget.data!.get("name"),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700])),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(widget.data!.get("desc")),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Files :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("courses")
                    .doc(widget.data!.id.toString())
                    .collection("files")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return (const Center(child: Text("No files Found")));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        String file = snapshot.data!.docs[index]['fileURL'];
                        String filename =
                            snapshot.data!.docs[index]['filename'];
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: GestureDetector(
                                  onTap: () async {
                                    String url = file;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      Alert();
                                    }
                                  },
                                  child: Text(
                                    filename,
                                    style: TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ]);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
        onTap: () async {
            String url = widget.data!.get("url");
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              Alert();
            }
          },
        child: Container(
          height: 48.0,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('See more >',
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
            ],
          ),
        ),
      ));
  }

  Alert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Appologies'),
            content: Text("link not available :'("),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok')),
            ],
          );
        });
  }
}
