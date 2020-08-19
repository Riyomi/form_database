import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:db_practice/database_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final prefs = SharedPreferences.getInstance();

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SignUpPage()
      )
    )
  ));
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  var _autoValidate = false;
  var _user;
  var _password;
  var _passwordRepeat;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
      Form (
      autovalidate: _autoValidate,
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              FlutterLogo(size: 100),
              SizedBox(height: 20),
              Text('Sign up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey,
                  )),
              SizedBox(height: 20),
              TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username'
                  ),
                  onChanged: (value) {
                    _user = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  }
              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password'
                ),
                onChanged: (value) {
                  _password = value;
                },
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Please enter your password';
                  } else if (!validateStructure(value)) {
                    return 'Your password is too weak';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Repeat password'
                ),
                onChanged: (value) {
                  _passwordRepeat = value;
                },
                validator: (value) {
                  if(value != _password) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                    color: Colors.blue,
                    child: Text('Sign up', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        print('$_user:$_password:$_passwordRepeat');
                        try {
                          await insertUser(new User(_user, _password));
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                                'Successfully submitted'),));
                        } on DatabaseException catch (_) {
                          print("Error");
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text(
                                'A user with this name already exists.'),));
                        }
                      } else {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('Problem submitting form'),));
                        setState(() {
                          _autoValidate = true;
                        });
                      }
                    }
                ),
              ),
            ],
          )
      ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Already a member? ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                )),
            InkWell(
              child: Text('Log in.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  )),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new Scaffold(
                        body: Padding(
                            padding: const EdgeInsets.all(20),
                            child: LoginPage()
                        )
                    )
                    ),
                  )
                }
            ),
          ],
        ),
      ],),
    );
  }
}

bool validateStructure(String value){
  String  pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  var _autoValidate = false;
  var _user;
  var _password;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Form (
            autovalidate: _autoValidate,
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                FlutterLogo(size: 100),
                SizedBox(height: 20),
                Text('Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey,
                    )),
                SizedBox(height: 20),
                TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username'
                    ),
                    onChanged: (value) {
                      _user = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password'
                  ),
                  onChanged: (value) {
                    _password = value;
                  },
                  validator: (value) {
                    if(value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                      color: Colors.blue,
                      child: Text('Login', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          print('$_user:$_password');
                          bool found = await getUser('$_user', '$_password');
                          if (found) {
                            Scaffold.of(context)
                                .showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Succesfully logged in.'),));
                            setState(() {
                              _autoValidate = true;
                            });
                          } else {
                            Scaffold.of(context)
                                .showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text('Username and password don\'t match.'),));
                            setState(() {
                              _autoValidate = true;
                            });
                          }
                        }
                      }
                  ),
                ),
              ],
            )
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Don\'t have an account? ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                )),
            InkWell(
                child: Text('Sign up.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    )),
                onTap: () => {
                  Navigator.pop(context)
                }
            ),
          ],
        ),
      ],),
    );
  }
}