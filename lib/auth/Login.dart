// ignore_for_file: deprecated_member_use, avoid_print, avoid_unnecessary_containers, prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SignUp.dart';

// ignore: use_key_in_widget_constructors
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _email, _password;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);
        Navigator.pushReplacementNamed(context, "initialhome");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_this
    this.checkAuthentification();
  }

  bool _obscureText = true;

  // Toggles the password show status
  // ignore: unused_element
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } catch (e) {
        showError();
        print(e);
      }
    }
  }

  showError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text("The email address or password are badly formatted."),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
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
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: TextFormField(
                          validator: (input) {
                            if (input!.isEmpty) return 'Enter Email';
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          onSaved: (input) => _email = input!),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: TextFormField(
                          validator: (input) {
                            if (input!.length < 6)
                              // ignore: curly_braces_in_flow_control_structures
                              return 'Provide Minimum 6 Character';
                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: InkWell(
                                  onTap: _toggle,
                                  child: Icon(_obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                          obscureText: _obscureText,
                          onSaved: (input) => _password = input!),
                    ),
                    SizedBox(height: 20),
                    Center(
                        child: ElevatedButton(
                            onPressed: login,
                            child: Padding(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Text('LOGIN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold))),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            )))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Don't have an account? ",
              ),
              GestureDetector(
                onTap: () {
                  navigateToSignUp();
                },
                child: Text(
                  "Register now",
                  style: TextStyle(
                      fontSize: 16, decoration: TextDecoration.underline),
                ),
              ),
            ]),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('resetpsw');
                },
                child: Text("Forgot password?"))
          ],
        ),
      ),
    ));
  }
}
