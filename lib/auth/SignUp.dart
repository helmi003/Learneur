// ignore: duplicate_ignore
// ignore_for_file: deprecated_member_use, avoid_unnecessary_containers, prefer_const_constructors, file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learneur/auth/verify.dart';
import 'package:email_validator/email_validator.dart';
// ignore: use_key_in_widget_constructors

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

enum SingingCharacter { male, female }

class _SignUpState extends State<SignUp> {
  // ignore: prefer_final_fields
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SingingCharacter? _character = SingingCharacter.male;
  late String _name, _email, _password, lastName, description;
  final TextEditingController confirmPass = TextEditingController();
  final TextEditingController pass = TextEditingController();

  bool _obscureText = true;
  bool _obscureText2 = true;

  // Toggles the password show status
  // ignore: unused_element
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

  navigateToLogin() async {
    Navigator.pushReplacementNamed(context, "Login");
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        String gender = _character.toString();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    //ChatPage(data: data)
                    VerifyScreen(
                        name: _name,
                        lastName: lastName,
                        email: _email,
                        password: _password,
                        gender: gender,
                        description: description.toString())));
      } catch (e) {
        print(e.toString());
        showError();
      }
    }
  }

  showError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content:
                Text("The email address is already in use by another account."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: TextFormField(
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Enter your name';
                          } else if (input.length < 5) {
                            return 'Provide Minimum 5 Character';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        onSaved: (input) => _name = input!)),
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: TextFormField(
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Enter your last name';
                          } else if (input.length < 5) {
                            return 'Provide Minimum 5 Character';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        onSaved: (input) => lastName = input!)),
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: TextFormField(
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
                        onSaved: (input) => _email = input!)),
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: TextFormField(
                        controller: pass,
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
                        onSaved: (input) => _password = input!)),
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: TextFormField(
                      controller: confirmPass,
                      validator: (input) {
                        if (input!.isEmpty)
                          return 'Enter your confimed password';
                        if (input != pass.text)
                          // ignore: curly_braces_in_flow_control_structures
                          return 'you have to wrirte the same password';
                      },
                      decoration: InputDecoration(
                          labelText: 'Confirm password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: InkWell(
                              onTap: _toggle2,
                              child: Icon(_obscureText2
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                      obscureText: _obscureText2,
                    )),
                SelectRadioButton(),
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: TextFormField(
                        minLines: 4,
                        maxLines: 4,
                        maxLength: 100,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter something to describe yourself';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                        hintText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        )),
                        onSaved: (input) => description = input!)),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: ElevatedButton(
                      
                        onPressed: signUp,
                        child: Text('SignUp',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ))),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                            ),
                            GestureDetector(
                              onTap: () {
                                navigateToLogin();
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ]),
                    ]),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget SelectRadioButton() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Male'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.male,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Female'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.female,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
