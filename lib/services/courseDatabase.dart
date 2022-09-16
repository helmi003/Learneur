import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CourseDatabaseMethods {
  final String uid;
  CourseDatabaseMethods({required this.uid});

  final CollectionReference courseCollection =
      FirebaseFirestore.instance.collection("courses");

  addCourse(String name, String type, String desc, String url, String displayName) async {
    return await courseCollection.add({
      "name": name,
      "type": type,
      "desc": desc,
      "user": uid,
      "url": url,
      "userName": displayName,
    }).catchError((e) {
      print(e.toString());
    });
  }

  modifyCourse(
      String id, String name, String type, String desc, String url) async {
    return await courseCollection.doc(id).update({
      "name": name,
      "type": type,
      "desc": desc,
      "user": uid,
      "url": url,
      
    }).catchError((e) {
      print(e.toString());
    });
  }

  Future deleteCourse(String id, String imageName) async {
    deleteImage(id, imageName);
    await courseCollection.doc(id).delete();
  }

  deleteFile(String courseID, String id, String filename) async {
    await FirebaseStorage.instance
        .ref()
        .child('Course/$courseID/files/$filename')
        .delete();
    await courseCollection.doc(courseID).collection("files").doc(id).delete();
  }

  deleteImage(String courseID, String imageName) async {
    await FirebaseStorage.instance
        .ref()
        .child('Course/$courseID/images/$imageName')
        .delete();
  }
}
