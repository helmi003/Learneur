import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learneur/auth/profileInfo.dart';
import 'package:learneur/chat/audioCall.dart';
import 'package:learneur/chat/videoCall.dart';
import 'ShowMessage.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String pic;
  final String id;
  final String userEmail;
  final String status;
  const ChatScreen({
    Key? key,
    required this.userName,
    required this.pic,
    required this.id,
    required this.userEmail,
    required this.status,
  }) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore storeMessage = FirebaseFirestore.instance;
  late User user;
  bool isloggedin = false;
  late final String userName = widget.userName;
  late final String pic = widget.pic;
  late final String id = widget.id;
  late final String userEmail = widget.userEmail;
  late final String status =widget.status;
  TextEditingController msg = new TextEditingController();
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            BackButton(),
            widget.pic.substring(0, 8) == "https://"
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      "${widget.pic}",
                    ))
                : CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                      "${widget.pic}",
                    )),
            Padding(padding: EdgeInsets.fromLTRB(4, 4, 4, 4)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.radio_button_checked,
                      color: status == "offline" ? Colors.grey : Colors.green,
                      size: 15,
                    ),
                    Text(
                      "${status}",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AudioCallScreen()));
              },
              icon: Icon(Icons.local_phone)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VideoCallScreen()));
              },
              icon: Icon(Icons.videocam)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileInfo(id: id)));
              },
              icon: Icon(Icons.info)),
        ],
      ),
      body: !isloggedin
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: ShowMessages(
                    userName: userName,
                    pic: pic,
                    userEmail: userEmail,
                  ),
                ),
              ],
            ),
      bottomSheet: SafeArea(
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  takephoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera)),
            IconButton(
                onPressed: () {
                  takephoto(ImageSource.gallery);
                },
                icon: Icon(Icons.image)),
            IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
            Expanded(
                child: TextField(
              controller: msg,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  hintText: "Message..."),
            )),
            IconButton(
                onPressed: () {
                  if (msg.text.isNotEmpty) {
                    storeMessage
                        .collection("chatRoom")
                        .doc(getChatRoomIdByUsernames(
                            user.email.toString(), widget.userEmail))
                        .collection("Messages")
                        .doc()
                        .set({
                      "message": msg.text.trim(),
                      "user": user.email.toString(),
                      "time": DateTime.now(),
                    });
                    //NotificationApi.showNotofication();
                    msg.clear();
                  }
                },
                icon: Icon(Icons.send)),
          ],
        ),
      ),
    );
  }

  Future takephoto(ImageSource source) async {
    final pick = await imagePicker.pickImage(source: source);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        uploadImage(_image!);
      }
    });
  }

  Future uploadImage(File _image) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(
            'Messages/${getChatRoomIdByUsernames(user.email.toString(), widget.userEmail)}/images')
        .child("post_$imgId");

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    await firebaseFirestore
        .collection("chatRoom")
        .doc(getChatRoomIdByUsernames(user.email.toString(), widget.userEmail))
        .collection("Messages")
        .doc()
        .set({
      "message": downloadURL,
      "user": user.email.toString(),
      "time": DateTime.now(),
    });
  }
}