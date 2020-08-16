import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:db_practice/database_handler.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: PageForm()
      )
    )
  ));
}

class PageForm extends StatefulWidget {
  @override
  _PageFormState createState() => _PageFormState();
}

class _PageFormState extends State<PageForm> {
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
              SizedBox(height: 20), //
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
              SizedBox(height: 20), // for extra place between the two widgets
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
              SizedBox(height: 20), //
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
              SizedBox(height: 20), // f
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                    color: Colors.blue,
                    child: Text('Submit', style: TextStyle(
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
                            content: Text('Successfully submitted'),));
                        } on DatabaseException catch (_) {
                          print("Error");
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('A user with this name already exists.'),));
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
              ),// or extra place between the two widgets
            ],
          )
      )
      ],),
    );

  }
}