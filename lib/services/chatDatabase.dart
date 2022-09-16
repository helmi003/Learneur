import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDatabaseMethods {
  final String uid;
  ChatDatabaseMethods({required this.uid});
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection("chatRoom");

  delete(String id) async {
    await chatCollection.doc(uid).collection("Messages").doc(id).delete();
  }
}
