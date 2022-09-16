// ignore_for_file: prefer_const_constructors, deprecated_member_use
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learneur/components/appbarsider.dart';
import 'package:learneur/components/bottombar.dart';
import 'package:learneur/courses.dart/adding/addfiles.dart';
import 'package:path/path.dart' as pth;
import '../../services/courseDatabase.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({Key? key}) : super(key: key);

  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController type = new TextEditingController();
  TextEditingController desc = new TextEditingController();
  TextEditingController url = new TextEditingController();
  late String courseID = '';
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String displayName =
      FirebaseAuth.instance.currentUser!.displayName.toString();

  @override
  Widget build(BuildContext context) {
    final fileName =
        _image != null ? pth.basename(_image!.path) : 'Select Background-Image';
    return Scaffold(
      appBar: appBarsider(context),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            Center(
              child: Text("Add New Course",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700])),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: name,
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
              controller: type,
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
              controller: desc,
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
              controller: url,
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
                        ? Image.network(
                            "https://firebasestorage.googleapis.com/v0/b/test-16d95.appspot.com/o/Course%2Fimage-not-availebale.jpg?alt=media&token=8165ea5f-ca4e-4fbd-a462-bdbd5e816eec")
                        : Image.file(_image!)),
              ),
            ),
            Center(child: Text(fileName)),
            SizedBox(height: 10),
            buttons(),
          ],
        ),
      ),
      bottomNavigationBar: bottombar(context, 0, "Add"),
    );
  }

  buttons() {
    return Center(
        child: ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (_image == null) {
            showSnackBar("Select image first", Duration(seconds: 2));
          } else {
            CourseDatabaseMethods(uid: uid)
                .addCourse(
                    name.text, type.text, desc.text, url.text, displayName)
                .then((value) => {
                      print(value.id),
                      setState(() {
                        courseID = value.id.toString();
                      }),
                      showSnackBar("Please wait a moment", Duration(seconds: 2))
                    })
                .whenComplete(() => uploadImage(_image!, courseID));
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

  Future uploadImage(File _image, String courseID) async {
    // final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final fileName = pth.basename(_image.path);
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('Course/$courseID/images/$fileName');

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    await firebaseFirestore.collection("courses").doc(courseID).update({
      'downloadURL': downloadURL,
      'imageName': fileName
    }).whenComplete(
        () => showSnackBar("Course Uploaded", Duration(seconds: 2)));
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddFiles(courseId: courseID)));
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
