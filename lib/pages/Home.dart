// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learneur/pages/AdminPage.dart';
import 'package:learneur/pages/HomePage.dart';

// ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;
  late bool permission = false;
  late final String status;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser!;
        this.isloggedin = true;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      UpdateUser("online");
    } else {
      UpdateUser("offline");
    }
  }

  UpdateUser(status) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      'status': status,
    });
  }

  @override
  void initState() {
    super.initState();
    this.getUser();
    this.checkAuthentification();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !isloggedin
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: UserData(),
                builder: (context, snapshot) {
                  return permission == true ? AdminPage() : HomePage();
                }));
  }

  UserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((ds) {
      setState(() {
        status = ds["status"];
      });
      permission = ds['permission'];
    }).catchError((e) {
      print(e);
    });
  }
}
