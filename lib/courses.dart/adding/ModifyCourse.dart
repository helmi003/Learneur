// ignore_for_file: prefer_const_constructors, deprecated_member_use
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learneur/components/appbarsider.dart';
import 'package:learneur/components/bottombar.dart';
import 'package:path/path.dart' as pth;
import 'package:learneur/courses.dart/adding/modifyFiles.dart';
import 'package:learneur/courses.dart/adding/viewers.dart';
import '../../services/courseDatabase.dart';

class ModifyCourse extends StatefulWidget {
  const ModifyCourse({this.data, required this.id});
  final QueryDocumentSnapshot<Object?>? data;
  final String id;

  @override
  _ModifyCourseState createState() => _ModifyCourseState();
}

class _ModifyCourseState extends State<ModifyCourse> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController type;
  late TextEditingController desc;
  late TextEditingController url;
  late final String id = widget.id;
  late final String name2 = widget.data!.get("name");
  late final String type2 = widget.data!.get("type");
  late final String desc2 = widget.data!.get("desc");
  late final String url2 = widget.data!.get("url");
  late final String image = widget.data!.get("downloadURL");
  late final String imageName = widget.data!.get("imageName");
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final fileName = _image != null ? pth.basename(_image!.path) : imageName;
    return Scaffold(
      appBar: appBarsider(context),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            Center(
              child: Text("Course Progress",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700])),
            ),
            SizedBox(height: 20),
            Center(
                child: TextButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Viewers(id: id)));
                    },
                    icon: Icon(
                      Icons.leaderboard,
                      color: Colors.white,
                    ),
                    label: Text('Progress ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)))),
            SizedBox(height: 20),
            Center(
              child: Text("Modify Course",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700])),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: name = TextEditingController(text: "${name2}"),
              validator: (String? value) {
                if (value!.isEmpty)
                  return 'Enter subject name';
                else if (value.length < 3)
                  return "it's too short";
                else if (value.length > 50) return "it's too long";
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'Course name',
                  prefixIcon: Icon(Icons.menu_book),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: type = TextEditingController(text: "${type2}"),
              validator: (String? value) {
                if (value!.isEmpty)
                  return 'Enter the course type';
                else if (value.length < 3)
                  return "it's too short";
                else if (value.length > 50) return "it's too long";
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'Course type',
                  prefixIcon: Icon(Icons.library_books),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: desc = TextEditingController(text: "${desc2}"),
              minLines: 4,
              maxLines: 4,
              maxLength: 500,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Enter a subject';
                } else if (value.length < 10) {
                  return "it's too short";
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  )),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: url = TextEditingController(text: "${url2}"),
              validator: (String? value) {
                if (value!.isEmpty) return 'Enter course url';
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'URL',
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                height: 120,
                width: 200,
                child: GestureDetector(
                    onTap: () {
                      imagePickerMethod();
                    },
                    child: _image == null
                        ? Image.network(image)
                        : Image.file(_image!)),
              ),
            ),
            Center(child: Text(fileName)),
            SizedBox(height: 10),
            buttons(),
          ],
        ),
      ),
      bottomNavigationBar: bottombar(context, 0, "Modify"),
    );
  }

  buttons() {
    return Center(
        child: ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          CourseDatabaseMethods(uid: uid)
              .modifyCourse(id, name.text, type.text, desc.text, url.text);
          if (_image == null) {
            showSnackBar("Successfuly modified", Duration(seconds: 2));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ModifyFiles(courseId: id)));
          } else {
            showSnackBar("Please wait a moment", Duration(seconds: 2));
            uploadImage(_image!, id, imageName);
          }
        }
      },
      child: const Text('Submit',
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
    ));
  }

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("There is no Image selected", Duration(milliseconds: 400));
      }
    });
  }

  Future uploadImage(File _image, String courseID, String imageName) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final fileName = pth.basename(_image.path);

    Reference reference = await FirebaseStorage.instance
        .ref()
        .child('Course/$courseID/images/$fileName');
    CourseDatabaseMethods(uid: uid).deleteImage(courseID, imageName);
    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    await firebaseFirestore.collection("courses").doc(courseID).update({
      'downloadURL': downloadURL,
      'imageName': fileName
    }).whenComplete(
        () => showSnackBar("Course Uploaded", Duration(seconds: 2)));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ModifyFiles(courseId: courseID)));
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
