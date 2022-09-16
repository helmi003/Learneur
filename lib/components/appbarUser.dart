import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'searchUser.dart';

PreferredSizeWidget appbarUser(BuildContext context) {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String mail = FirebaseAuth.instance.currentUser!.email.toString();
  return AppBar(title: Image.asset('images/appbar.png',height: 25,),
          centerTitle: true,
          backgroundColor: Colors.orange,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search),onPressed: (){
              showSearch(context: context, delegate: SearchUser(mail: mail,uid: uid));
            })
          ],
          elevation: 6,
  );
}
