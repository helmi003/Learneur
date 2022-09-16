import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final String uid;
  DatabaseMethods({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future UpdateUserData(
      String userName,
      String lastName,
      String userEmail,
      bool permission,
      String gen,
      String profilePic,
      String status,
      String description) async {
    return await userCollection.doc(uid).set({
      "userName": userName,
      "lastName": lastName,
      "userEmail": userEmail,
      "permission": permission,
      "gender": gen,
      "profilePic": profilePic,
      "status": "online",
      "description": description,
    });
  }

  updateProfile(String userName, String lastName, String description) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
          'userName': userName,
          'lastName': lastName,
          'description': description,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  addFriendUser(String mail, String friend) {
    return FirebaseFirestore.instance
        .collection("friends")
        .doc(uid)
        .collection(mail)
        .doc(friend)
        .set({
      'userEmail': friend,
    });
  }

  FindFriend(String mail, String friend) async {
    String friend2;
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(uid)
        .collection(mail)
        .doc(friend)
        .get()
        .then((ds) {
          friend2 = ds['friend'];
          if(friend2.compareTo(friend)==0){
            return true;
          }
    });
    return false;
  }
}
