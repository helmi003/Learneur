// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class drawer extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<drawer> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User user;

  @override
  void initState() {
    user = auth.currentUser!;
    super.initState();
  }

  signOut() async {
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("${user.displayName}",
                style: TextStyle(color: Colors.white)),
            accountEmail:
                Text("${user.email}", style: TextStyle(color: Colors.white)),
            currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('profile');
                },
                child: user.photoURL.toString().substring(0, 8) == "https://"
                    ? CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage("${user.photoURL}"))
                    : CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage("${user.photoURL}"))),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/user-background.png"),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            title: Text(
              "Home page",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.home,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, "initialhome");
            },
          ),
          ListTile(
            title: Text(
              "Friends",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.group,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('friends');
            },
          ),
          Divider(
            color: Colors.black,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            title: Text("Settings", style: TextStyle(fontSize: 18)),
            leading: Icon(
              Icons.settings,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('settings');
            },
          ),
          ListTile(
            title: Text("About", style: TextStyle(fontSize: 18)),
            leading: Icon(
              Icons.info,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('about');
            },
          ),
          ListTile(
            title: Text("Log out", style: TextStyle(fontSize: 18)),
            leading: Icon(
              Icons.logout,
            ),
            onTap: signOut,
          ),
        ],
      ),
    );
  }
}
