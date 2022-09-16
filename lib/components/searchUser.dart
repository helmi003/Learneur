// ignore_for_file: prefer_const_constructors, file_names, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learneur/chat/ChatScreen.dart';
import 'package:learneur/services/userDatabase.dart';

class SearchUser extends SearchDelegate {
  // ignore: prefer_final_fields
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("users");
  SearchUser({required this.mail, required this.uid});
  late String mail;
  late String uid;

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              return Center(child: Text("No user found"));
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
                                        status: status
                                        )));
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
                                                .addFriendUser(mail, userEmail);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('YES'))
                                    ],
                                  );
                                });
                          }
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
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text("Search for your friends by name"));
  }
}
