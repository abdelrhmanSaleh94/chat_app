import 'package:flutter/material.dart';
import './screen/chatscreen.dart';
import './screen/login_screen.dart';
import './screen/registrationscreen.dart';
import './screen/chatuser_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        RegistrationScreen.routeName: (ctx) => RegistrationScreen(),
        ChatUsers.routeName: (ctx) => ChatUsers(),
        ChatScreen.routeName: (ctx) => ChatScreen()
      },
    );
  }
}
