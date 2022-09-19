// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learneur/components/appbarUser.dart';
import 'package:learneur/components/drawer.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  late String gender;
  late String description;
  late String lastName;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String mail = FirebaseAuth.instance.currentUser!.email.toString();
  String name = FirebaseAuth.instance.currentUser!.uid;
  String photoURL = FirebaseAuth.instance.currentUser!.photoURL.toString();
  String displayName = FirebaseAuth.instance.currentUser!.displayName.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbarUser(context),
        drawer: drawer(),
        // ignore: prefer_const_literals_to_create_immutables()
        body: FutureBuilder(
                future: _fetch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(child: CircularProgressIndicator());
                  return ListView(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                          child: photoURL.substring(0, 8) ==
                                  "https://"
                              ? CircleAvatar(
                                  radius: 80,
                                  backgroundImage: NetworkImage(
                                    "${photoURL}",
                                  ))
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundImage: AssetImage(
                                    "${photoURL}",
                                  ))),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        "${displayName} ${lastName}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        "${mail}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        "${gender}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        "${description}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      // ignore: deprecated_member_use
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('editProfile');
                          },
                          child: Text('Edit profile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }));
  }

  _fetch() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((ds) {
      gender = ds['gender'];
      description = ds['description'];
      lastName = ds['lastName'];
    }).catchError((e) {
      print(e);
    });
  }
}
