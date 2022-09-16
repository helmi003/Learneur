// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learneur/components/searchUser.dart';

class ProfileInfo extends StatefulWidget {
  final String id;
  const ProfileInfo({
    required this.id,
  });

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late String gender;
  late String description;
  late String userName;
  late String profilePic;
  late String userEmail;
  late String lastName;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String mail = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Image.asset('images/appbar.png',height: 25,),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SearchUser(mail: mail,uid: uid));
              })
        ],
        elevation: 6,
      ),
        // ignore: prefer_const_literals_to_create_immutables
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
                    child: profilePic.substring(0, 8) == "https://"
                        ? CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(
                              "${profilePic}",
                            ))
                        : CircleAvatar(
                            radius: 80,
                            backgroundImage: AssetImage(
                              "${profilePic}",
                            )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Text(
                    "${userName} ${lastName}",
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
                    "${userEmail}",
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
                ],
              );
            }));
  }

  _fetch() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get()
        .then((ds) {
      gender = ds['gender'];
      userName = ds['userName'];
      userEmail = ds['userEmail'];
      profilePic = ds['profilePic'];
      lastName = ds['lastName'];
      description = ds['description'];
    }).catchError((e) {
      print(e);
    });
  }
}
