// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as pth;
import 'package:learneur/components/appbarsider.dart';
import 'package:learneur/components/bottombar.dart';
import 'package:learneur/services/courseDatabase.dart';
import '../firebase_api.dart';
import 'package:url_launcher/url_launcher.dart';

class ModifyFiles extends StatefulWidget {
  final String? courseId;
  const ModifyFiles({Key? key, this.courseId}) : super(key: key);

  @override
  _ModifyFilesState createState() => _ModifyFilesState();
}

class _ModifyFilesState extends State<ModifyFiles> {
  UploadTask? task;
  File? file;
  late String courseID=widget.courseId.toString();
  String id = "";
  String query = "";

  @override
  Widget build(BuildContext context) {
    final fileName =
        file != null ? pth.basename(file!.path) : 'No File Selected';
    return Scaffold(
      appBar: appBarsider(context),
      body: Container(
          child: ListView(
        children: [
          Center(
            child: Text("Modify File/Files",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700])),
          ),
          SizedBox(height: 30),
          Center(
              child: TextButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: selectFile,
                  icon: Icon(
                    Icons.attach_file,
                    color: Colors.white,
                  ),
                  label: Text('Select file ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)))),
          Center(child: Text(fileName)),
          SizedBox(height: 10),
          Center(
              child: TextButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: uploadFile,
                  icon: Icon(
                    Icons.upload_file,
                    color: Colors.white,
                  ),
                  label: Text('Upload file ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)))),
          SizedBox(height: 10),
          Center(
              child: task != null
                  ? buildUploadStatus(task!)
                  : Text("Progress : 0.00 %",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
          SizedBox(
            height: 30,
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
                .doc(courseID)
                .collection("files")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs
                        .where((QueryDocumentSnapshot<Object?> element) =>
                            element['filename']
                                .toString()
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .isEmpty) {
                      return SizedBox(
                          height: 20,
                          child: Center(child: Text("No course found")));
                    } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    String filename = snapshot.data!.docs[index]['filename'];
                    String fileURL = snapshot.data!.docs[index]['fileURL'];

                    id = snapshot.data!.docs[index].id;

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                              onLongPress: () {
                                Alert2(filename);
                              },
                              onTap: () async {
                                String url = fileURL;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  Alert();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  filename,
                                  style: TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.underline),
                                ),
                              )),
                        ]);
                  },
                );
              }
            },
          ),
          Center(
              child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "admin");
            },
            child: const Text('Finish',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ))
        ],
      )),
      bottomNavigationBar: bottombar(context, 1, "Modify"),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final fileName = pth.basename(file!.path);
    final destination = 'Course/${courseID}/files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});
    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    await firebaseFirestore
        .collection("courses")
        .doc(courseID)
        .collection("files")
        .add({'fileURL': urlDownload, 'filename': fileName});
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              'Progress : $percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
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

  Alert2(String filename) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text("do you want really to delete this!"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
              TextButton(
                  onPressed: () {
                    CourseDatabaseMethods(uid: courseID)
                        .deleteFile(courseID, id, filename)
                        .whenComplete(() {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text('Yes')),
            ],
          );
        });
  }
}
