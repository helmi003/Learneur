// ignore_for_file: prefer_const_constructors, duplicate_ignore
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learneur/components/appbarUser.dart';
import 'package:learneur/components/drawer.dart';
import 'package:learneur/services/userDatabase.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String profilePic;
  late String lastName;
  late String description;
  late String userName;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User user;

  @override
  void initState() {
    user = auth.currentUser!;
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _description;
  late TextEditingController _lastName;
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbarUser(context),
        drawer: drawer(),
        // ignore: prefer_const_literals_to_create_immutables
        body: Form(
            key: _formKey,
            child: FutureBuilder(
                future: _fetch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(child: CircularProgressIndicator());
                  return ListView(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      imageprofile(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: TextFormField(
                          controller: _name =
                              TextEditingController(text: "${userName}"),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter new name';
                            } else if (value.length < 4) {
                              return "Name too short";
                            } else if (value.length > 50) {
                              return "Name too long";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Name",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: TextFormField(
                          controller: _lastName =
                              TextEditingController(text: "${lastName}"),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter your new last name';
                            } else if (value.length < 4) {
                              return "Last name too short";
                            } else if (value.length > 50) {
                              return "Last name too long";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Last name",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                        child: TextFormField(
                          controller: _description =
                              TextEditingController(text: "${description}"),
                          minLines: 4,
                          maxLines: 4,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter your description';
                            } else if (value.length < 4) {
                              return "Description too short";
                            } else if (value.length > 200) {
                              return "Description too long";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_image != null) {
                                afficher_SnackBar2(context);
                                DatabaseMethods(uid: user.uid).updateProfile(
                                    _name.text,
                                    _lastName.text,
                                    _description.text);
                                user.updateDisplayName(_name.text);
                                uploadImage(_image!);
                              }
                            } else {
                              DatabaseMethods(uid: user.uid).updateProfile(
                                  _name.text,
                                  _lastName.text,
                                  _description.text);
                              user.updateDisplayName(_name.text);
                              afficher_SnackBar(
                                  context, " Profile updated successfuly");
                            }
                          },
                          child: const Text('Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })));
  }

  _fetch() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((ds) {
      description = ds['description'];
      userName = ds['userName'];
      lastName = ds['lastName'];
      profilePic = ds['profilePic'];
    }).catchError((e) {
      print(e);
    });
  }

  afficher_SnackBar(BuildContext context, String txt) {
    var monsnackbar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.task_alt,
            size: 40,
          ),
          Expanded(
            child: Text(
              txt,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      duration: Duration(seconds: 2),
      shape: StadiumBorder(),
      backgroundColor: Colors.orange,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    );
    ScaffoldMessenger.of(context).showSnackBar(monsnackbar);
  }

  afficher_SnackBar2(BuildContext context) {
    var monsnackbar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            size: 40,
          ),
          Expanded(
            child: Text(
              " please wait a moment",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      duration: Duration(seconds: 2),
      shape: StadiumBorder(),
      backgroundColor: Colors.orange,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    );
    ScaffoldMessenger.of(context).showSnackBar(monsnackbar);
  }

  Widget imageprofile() {
    return Center(
      child: Stack(
        children: <Widget>[
          _image != null
              ? CircleAvatar(
                  radius: 80,
                  backgroundImage: FileImage(
                    _image!,
                  ))
              : user.photoURL.toString().substring(0, 8) == "https://"
                  ? CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                        "${user.photoURL}",
                      ))
                  : CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage(
                        "${user.photoURL}",
                      )),
          Positioned(
            bottom: 20,
            right: 20,
            child: InkWell(
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28,
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context, builder: ((builder) => bottomsheet()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Future takephoto(ImageSource source) async {
    final pick = await imagePicker.pickImage(source: source);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      }
    });
  }

  Widget bottomsheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text("Choose your profile photo :",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    takephoto(ImageSource.camera);
                  },
                  icon: Icon(
                    Icons.camera,
                    color: Colors.orange,
                  ),
                  label: Text("Camera", style: TextStyle(color: Colors.black))),
              TextButton.icon(
                  onPressed: () {
                    takephoto(ImageSource.gallery);
                  },
                  icon: Icon(
                    Icons.image,
                    color: Colors.orange,
                  ),
                  label:
                      Text("Gallery", style: TextStyle(color: Colors.black))),
            ],
          )
        ],
      ),
    );
  }

  Future uploadImage(File _image) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('Profile iamges/${user.uid}')
        .child("post_$imgId");

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();
    user.updatePhotoURL(downloadURL);
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .update({'profilePic': downloadURL}).whenComplete(
            () => afficher_SnackBar(context, " Profile updated successfuly"));
  }
}
