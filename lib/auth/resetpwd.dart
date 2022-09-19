// ignore_for_file: prefer_const_constructors

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Resetpwd extends StatefulWidget {
  @override
  _ResetpswState createState() => _ResetpswState();
}

class _ResetpswState extends State<Resetpwd> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showmessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('request sent'),
            content: Text("we have sent you an Email adress"),
            actions: <Widget>[
              // ignore: deprecated_member_use
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('Login');
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  late String _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // ignore: sized_box_for_whitespace
          Container(
            height: 400,
            child: Image(
              image: AssetImage("images/login.png"),
              fit: BoxFit.contain,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                    validator: (String? value) {
                      final bool isValid = EmailValidator.validate(value!);
                      if (value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!isValid) {
                        return 'this is not a correct mail';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Email', prefixIcon: Icon(Icons.email)),
                    onChanged: (value) {
                      setState(() {
                        _email = value.trim();
                      });
                    }),
                SizedBox(height: 20),
                // ignore: deprecated_member_use
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _auth.sendPasswordResetEmail(email: _email);
                        showmessage();
                      }
                    },
                    child: Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Text('Send Request',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('Login');
                    },
                    child: Text("Login?"))
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
