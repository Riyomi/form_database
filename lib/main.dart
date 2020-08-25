import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:db_practice/database_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: LoginPage(),
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
                          await insertUser(new User(null, _user, _password));
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
                  Navigator.pushReplacement(
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
                          bool found = await doUserAndPasswordMatch('$_user', '$_password');
                          if (found) {
                            Scaffold.of(context)
                                .showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Succesfully logged in.'),));
                            setState(() {
                              _autoValidate = true;
                            });
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('username', '$_user');
                            Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => new Scaffold(
                                  body: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: WelcomePage()
                                  )
                              )
                              ),
                            );
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
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => new Scaffold(
                        body: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SignUpPage()
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

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();

  String _username;
  String _newUsername;

  @override
  Widget build(BuildContext context) {
    _updateUsername();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome $_username !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey
              )
            ),
            RaisedButton(
              child: Text('Logout'),
              onPressed: () async => {
                _logout(),
                Navigator.pushReplacement(context,
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username'
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Please enter a new username';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _newUsername = value;
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                        color: Colors.blue,
                        child: Text('Change username', style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                        onPressed: () async {
                          print(_newUsername);
                          if (_formKey.currentState.validate()) {
                              //await updateUser(new User(null, '$_username', null), '$_newUsername');
                              bool successful = await updateUserName('$_username', '$_newUsername');
                              if(successful) {
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Username changed from $_username to $_newUsername'),));
                              }
                          }
                        }
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  void _updateUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = '';
      prefs.clear();
    });
  }
}