import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learneur/services/chatDatabase.dart';

class ShowMessages extends StatefulWidget {
  final String userName;
  final String pic;
  final String userEmail;
  const ShowMessages({
    Key? key,
    required this.userName,
    required this.pic,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<ShowMessages> createState() => _ShowMessagesState();
}

class _ShowMessagesState extends State<ShowMessages> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;
  bool showTime = false;
  bool showTime2 = false;

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

  getChatRoomIdByUsernames(String a, String b) {
    if (a.compareTo(b) == 1) {
      return "$a\_$b";
    } else {
      return "$b\_$a";
    }
  }

  @override
  void initState() {
    super.initState();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return !isloggedin
        ? Center(child: CircularProgressIndicator())
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chatRoom")
                .doc(getChatRoomIdByUsernames(
                    user.email.toString(), widget.userEmail))
                .collection("Messages")
                .orderBy("time")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  primary: true,
                  itemBuilder: (context, i) {
                    QueryDocumentSnapshot x = snapshot.data!.docs[i];
                    String id = snapshot.data!.docs[i].id;
                    return user.email == x['user']
                        ? ListTile(
                            onLongPress: () {
                              Alert(id);
                            },
                            onTap: () {
                              setState(() {
                                showTime = !showTime;
                              });
                            },
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: showTime
                                        ? Text(DateFormat('kk:mm')
                                            .format(x["time"].toDate()))
                                        : Text(''),
                                  )
                                ]),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      color: Colors.orange[400]),
                                  child: Text(x["message"]),
                                )
                              ],
                            ),
                          )
                        : ListTile(
                            onTap: () {
                              setState(() {
                                showTime2 = !showTime2;
                              });
                            },
                            leading: Container(
                              padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                              child: widget.pic.substring(0, 8) == "https://"
                                  ? CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          NetworkImage("${widget.pic}"))
                                  : CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                        "${widget.pic}",
                                      )),
                            ),
                            subtitle: Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: showTime2
                                  ? Text(DateFormat('kk:mm')
                                      .format(x["time"].toDate()))
                                  : Text(''),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(
                                      widget.userName.toString(),
                                    )),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    color: Colors.orange,
                                  ),
                                  child: Text(x["message"]),
                                )
                              ],
                            ),
                          );
                  });
            });
  }

  Alert(String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text("Do you want to delete this message ?"),
            actions: <Widget>[
              // ignore: deprecated_member_use
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
              // ignore: deprecated_member_use
              TextButton(
                  onPressed: () {
                    ChatDatabaseMethods(
                            uid: getChatRoomIdByUsernames(
                                user.email.toString(), widget.userEmail))
                        .delete(id);
                    Navigator.of(context).pop();
                  },
                  child: Text('YES'))
            ],
          );
        });
  }
}
