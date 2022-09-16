// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learneur/services/userDatabase.dart';

class VerifyScreen extends StatefulWidget {
  final String name;
  final String lastName;
  final String email;
  final String password;
  final String gender;
  final String description;
  const VerifyScreen({
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.description,
  });

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  late final String name = widget.name;
  late final String email = widget.email;
  late final String password = widget.password;
  late final String gender = widget.gender;
  late final String lastName = widget.lastName;
  late final String description = widget.description;

  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: [
        SizedBox(
          height: 100,
        ),
        Text(
          "An email has been sent to :",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        Text(
          "${user.email}",
          style: TextStyle(
            color: Colors.orange,
            fontSize: 20.0,
          ),
        ),
        Text(
          "Please Verify!!",
          style: TextStyle(
            fontSize: 20.0,
          ),
        )
      ]),
    ));
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();

    try {
      bool perm = false;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String gen = gender.substring(17);
      String pic = "images/" + gen + ".png";
      String status = "offline";
      // ignore: deprecated_member_use
      await auth.currentUser!.updateProfile(displayName: name, photoURL: pic);
      await DatabaseMethods(uid: uid).UpdateUserData(
          name, lastName, email, perm, gen, pic, status, description);
      if (user.emailVerified) {
        timer.cancel();
        Navigator.pushReplacementNamed(context, "starting");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
