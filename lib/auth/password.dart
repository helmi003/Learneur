// ignore_for_file: prefer_const_constructors, duplicate_ignore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learneur/components/appbarsider.dart';
import 'package:learneur/components/drawer.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User user;

  @override
  void initState() {
    user = auth.currentUser!;
    super.initState();
  }

  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  void _toggle3() {
    setState(() {
      _obscureText3 = !_obscureText3;
    });
  }

  final TextEditingController confirmPass = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController pwd = TextEditingController();
  late String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarsider(context),
        drawer: drawer(),
        // ignore: prefer_const_literals_to_create_immutables
        body: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text("Change your password",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700])),
                ),
                SizedBox(height: 30),
                TextFormField(
                    controller: pwd,
                    validator: (input) {
                      if (input!.isEmpty)
                        // ignore: curly_braces_in_flow_control_structures
                        return 'you have to enter your old password';
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Current Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: InkWell(
                            onTap: _toggle3,
                            child: Icon(_obscureText3
                                ? Icons.visibility_off
                                : Icons.visibility))),
                    obscureText: _obscureText3),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                    controller: pass,
                    validator: (input) {
                      if (input!.length < 6)
                        // ignore: curly_braces_in_flow_control_structures
                        return 'Provide Minimum 6 Character';
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'New Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: InkWell(
                            onTap: _toggle,
                            child: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility))),
                    obscureText: _obscureText,
                    onSaved: (input) => _password = input!),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: confirmPass,
                  validator: (input) {
                    if (input!.isEmpty) return 'Enter your confimed password';
                    if (input != pass.text)
                      // ignore: curly_braces_in_flow_control_structures
                      return 'you have to wrirte the same password';
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: 'Confirm password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                          onTap: _toggle2,
                          child: Icon(_obscureText2
                              ? Icons.visibility_off
                              : Icons.visibility))),
                  obscureText: _obscureText2,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                    // ignore: deprecated_member_use
                    child: Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                try {
                                  await auth.signInWithEmailAndPassword(
                                      email: user.email.toString(),
                                      password: pwd.text);
                                  user.updatePassword(_password).then((_) {
                                    validate();
                                  }).catchError((error) {
                                    cancel();
                                  });
                                } catch (e) {
                                  cancel();
                                }
                              }
                            },
                            child: Text('Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ))))
              ],
            )));
  }

  cancel() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text("Password can't be changed"),
            actions: <Widget>[
              // ignore: deprecated_member_use
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  validate() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Validation'),
            content: Text("Successfully changed password"),
            actions: <Widget>[
              // ignore: deprecated_member_use
              TextButton(
                  onPressed: () {
                    signOut();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  signOut() async {
    auth.signOut();
  }
}
