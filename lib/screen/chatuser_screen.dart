import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/userModel.dart';
import '../widget/user_card.dart';

class ChatUsers extends StatefulWidget {
  static const routeName = '/ChatUsers';

  @override
  _ChatUsersState createState() => _ChatUsersState();
}

class _ChatUsersState extends State<ChatUsers> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Firestore _firestore = Firestore.instance;

  FirebaseUser loginUser;

  void getCrrentUser() async {
    try {
      final _user = await _auth.currentUser();
      if (_user != null) {
        loginUser = _user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCrrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          'Neoxero',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.windowClose),
            onPressed: () {
              _auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('Users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final usersData = snapshot.data.documents;
            List<UserModel> users = [];
            for (var user in usersData) {
              if (user['email'] != loginUser.email) {
                users.add(UserModel(
                    name: user['name'],
                    email: user['email'],
                    userId: user.documentID,
                    image: 'assets/images/person.jpg'));
              }
            }
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, i) {
                  return UserCard(
                    name: users[i].name,
                    email: users[i].email,
                    assetsImage: users[i].image,
                    userId: users[i].userId,
                  );
                });
          },
        ),
      ),
    );
  }
}
