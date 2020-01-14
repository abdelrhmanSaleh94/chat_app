import 'package:chat_app/screen/chatuser_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../widget/bottom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../helper/http_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _passwordController = TextEditingController();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _fileStore = Firestore.instance;
  bool _showProg = false;
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _showProg = false;
              });
            },
          )
        ],
      ),
    );
  }

  void _submite() async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProg = true;
      });
      try {
        final user = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        FirebaseUser loginUser;
        final _user = await _auth.currentUser();
        if (_user != null) {
          loginUser = _user;
        }
        await _fileStore.collection('Users').document(loginUser.uid).setData(
            {'name': _nameController.text, 'email': _emailController.text});
        if (user != null) {
          Navigator.pushReplacementNamed(context, ChatUsers.routeName);
        }
      } on HttpException catch (error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
          errorMessage = 'This email address is already in use.';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak.';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email.';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password.';
        }
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage =
            'Could not authenticate you. Please try again later.';
        _showErrorDialog(errorMessage);
      }
    }
    setState(() {
      _showProg = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: _showProg,
      child: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.mirror),
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(10, size.height * .20, 10, 2),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      filled: true,
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.brown, fontSize: 20),
                      fillColor: Colors.white),
                  onChanged: (value) {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email Not Valied';
                    }
                  },
                  textAlign: TextAlign.center,
                  controller: _emailController,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      filled: true,
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.brown, fontSize: 20),
                      fillColor: Colors.white),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Name Not Valied';
                    }
                  },
                  textAlign: TextAlign.center,
                  controller: _nameController,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      filled: true,
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.brown,
                        fontSize: 16,
                      ),
                      fillColor: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonDetials(
                  icon: Icons.send,
                  colorIcon: Colors.white,
                  onTap: _submite,
                  title: 'Signup',
                  colorButton: Colors.black54,
                  titleColor: Colors.white,
                ),
              ]),
            ),
          ),
        ),
      )),
    ));
  }
}
