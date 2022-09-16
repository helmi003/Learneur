// ignore_for_file: file_names, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learneur/chat/ChatScreen.dart';
import 'package:learneur/components/appbarUser.dart';
import 'package:learneur/components/drawer.dart';
import 'package:learneur/services/userDatabase.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("users");
  String query = "";
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String mail = FirebaseAuth.instance.currentUser!.email.toString();
  String name = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarUser(context),
      drawer: drawer(),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firebaseFirestore.snapshots().asBroadcastStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.docs
                  .where((QueryDocumentSnapshot<Object?> element) =>
                      element['userName']
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                  .isEmpty) {
                return Center(child: Text("No friend found"));
              } else {
                return ListView(
                  children: [
                    ...snapshot.data!.docs
                        .where((QueryDocumentSnapshot<Object?> element) =>
                            element['userName']
                                .toString()
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .map((QueryDocumentSnapshot<Object?> data) {
                      final String userName = data.get("userName");
                      final String id = data.id;
                      final String userEmail = data["userEmail"];
                      final String pic = data["profilePic"];
                      final String status = data["status"];
                      if (mail != userEmail) {
                        return ListTile(
                          leading: pic.substring(0, 8) == "https://"
                              ? CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    "${pic}",
                                  ))
                              : CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    "${pic}",
                                  )),
                          title: Text(userName),
                          subtitle: Text(userEmail),
                          trailing: Icon(Icons.send),
                          onTap: () async {
                            bool test = false;
                            String fr = "";
                            await FirebaseFirestore.instance
                                .collection('friends')
                                .doc(uid)
                                .collection(mail)
                                .doc(userEmail)
                                .get()
                                .then((value) {
                              fr = value['userEmail'];
                              if (userEmail.compareTo(fr) == 0) {
                                test = true;
                              }
                            }).catchError((e) {
                              print(e);
                            });

                            if (test) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          userName: userName,
                                          pic: pic,
                                          id: id,
                                          userEmail: userEmail,
                                          status: status)));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Add Friend'),
                                      content: Text(
                                          "$userName isn't your friend yet. Do you wanna add him/her ?"),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('No')),
                                        TextButton(
                                            onPressed: () {
                                              DatabaseMethods(uid: uid)
                                                  .addFriendUser(
                                                      mail, userEmail);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('YES'))
                                      ],
                                    );
                                  });
                            }
                          },
                          onLongPress: () async {
                            await FirebaseFirestore.instance
                                .collection('friends')
                                .doc(uid)
                                .collection(mail)
                                .doc(userEmail)
                                .get()
                                .then((value) {
                              String fr = value['userEmail'];
                              if (userEmail.compareTo(fr) == 0) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Add Friend'),
                                        content: Text(
                                            "Do you want to delete from friend list ?"),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('No')),
                                          TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('friends')
                                                    .doc(uid)
                                                    .collection(mail)
                                                    .doc(userEmail)
                                                    .delete();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('YES'))
                                        ],
                                      );
                                    });
                              }
                            }).catchError((e) {
                              print(e);
                            });
                          },
                        );
                      } else {
                        return Container();
                      }
                    })
                  ],
                );
              }
            }
          }),
    );
  }
}
