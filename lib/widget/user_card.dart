import '../screen/chatscreen.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String assetsImage;
  final String email;
  final String userId;

  const UserCard(
      {@required this.name,
      @required this.assetsImage,
      @required this.email,
      @required this.userId});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, ChatScreen.routeName,
                  arguments: userId);
            },
            title: Text(name),
            leading: CircleAvatar(
              radius: 30.0,
              child: ClipOval(
                child: Image.asset(assetsImage),
              ),
              backgroundColor: Colors.transparent,
            ),
            subtitle: Text(email),
          ),
        ],
      ),
    );
  }
}
