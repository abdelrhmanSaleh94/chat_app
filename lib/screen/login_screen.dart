import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../screen/chatuser_screen.dart';
import './registrationscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/bottom.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _showProgress = false;
  final _passwordController = TextEditingController();

  final _emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;
      });
      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        if (user != null) {
          print('welcome');
          Navigator.pushReplacementNamed(context, ChatUsers.routeName);
        }
        setState(() {
          _showProgress = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          _showProgress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showProgress,
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
                  child: Column(
                    children: <Widget>[
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
                            labelStyle:
                                TextStyle(color: Colors.brown, fontSize: 20),
                            fillColor: Colors.white),
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password Not Valied';
                            }
                          },
                          textAlign: TextAlign.center,
                          controller: _passwordController,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ButtonDetials(
                        icon: Icons.send,
                        colorIcon: Colors.white,
                        onTap: () {
                          _submit(context);
                        },
                        title: 'Login',
                        colorButton: Colors.black54,
                        titleColor: Colors.white,
                      ),
                      ButtonDetials(
                        icon: Icons.send,
                        colorIcon: Colors.white,
                        onTap: () {
                          Navigator.pushNamed(
                              context, RegistrationScreen.routeName);
                        },
                        title: 'Registration',
                        colorButton: Colors.redAccent,
                        titleColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
