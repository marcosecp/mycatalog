
import 'package:flutter/material.dart';
import 'package:flutterbook/api/book_api.dart';
import 'package:flutterbook/models/user.dart';
import 'package:flutterbook/notifiers/auth_notifier.dart';
import 'package:flutterbook/shared/constants.dart';
import 'package:flutterbook/shared/loading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  bool loading = false;
  User _user = User();

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    logIn(_user, authNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        centerTitle: false,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(FontAwesomeIcons.user, color: Colors.yellow,),
              label: Text('Register', style: TextStyle(color: Colors.white),))
        ],
        backgroundColor: Colors.brown[900],
        elevation: 0.0,
        title: Text('Sign in to FlutterBook'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Text('Already registered?', style: TextStyle(fontSize: 20, color: Colors.black54),),
              SizedBox(height: 20,),
              TextFormField(
                decoration: textInputDecoration,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                      .hasMatch(val)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onChanged: (val) {
                  setState(() {
                    _user.email = val;
                  });
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val.length < 6 ? 'Enter an password 6+ chars long' : null,
                controller: _passwordController,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    _user.password = val;
                  });
                },
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.yellow,
                child: Text(
                  'Sign In', style: TextStyle(color: Colors.black),
                ),
                onPressed: () => _submitForm(),
              ),
              SizedBox(height: 12,),
            ],
          ),
        ),
      ),
    );
  }
}
