import 'package:chat_app/model/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widget/messageitem.dart';

class ChatScreen extends StatefulWidget {
  static final routeName = '/ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

String chatId;

final Firestore _firestore =Firestore.instance;
FirebaseUser loginUser;
final FirebaseAuth _auth = FirebaseAuth.instance;

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  String msg;
  void getCrrentUser() async {
    try {
      final _user = await _auth.currentUser();
      if (_user != null) {
        loginUser = _user;
        chatId = loginUser.uid + DateTime.now().toIso8601String();
      }
    } catch (e) {
      print(e);
    }
  }

  String userid;
  @override
  void initState() {
    getCrrentUser();
    super.initState();
  }

  void _sendMessage() async {
    if (_messageController != null && _messageController.text.isNotEmpty) {
      print(_messageController.text);
      await _firestore
          .collection('Users')
          .document(loginUser.uid)
          .collection('connection')
          .document(userid)
          .get()
          .then((doc) async {
        if (doc.exists) {
          print('found');
          setState(() {
            chatId = doc.data['chatId'];
          });
        } else {
          print('Not Found');
          await _firestore
              .collection('Users')
              .document(loginUser.uid)
              .collection('connection')
              .document(userid)
              .setData({'chatId': chatId});
        }
      });
      await _firestore
          .collection('Users')
          .document(userid)
          .collection('connection')
          .document(loginUser.uid)
          .get()
          .then((doc) async {
        if (doc.exists) {
          setState(() {
            chatId = doc.data['chatId'];
          });
        } else {
          await _firestore
              .collection('Users')
              .document(userid)
              .collection('connection')
              .document(loginUser.uid)
              .setData({'chatId': chatId});
        }
      });

      final send = await _firestore
          .collection('Message')
          .document(chatId)
          .collection('Chat')
          .add({
        'message': _messageController.text,
        'sender': loginUser.email,
        'time': DateTime.now().toString(),
        'delivered': true
      });
      if (send != null) {
        _messageController.clear();
      }
    } else {
      print('no');
    }
  }

  @override
  Widget build(BuildContext context) {
    userid = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              child: MesssageStream(),
              color: Colors.amberAccent,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Enter a Message...",
                      border: const OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 100,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.blueAccent,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MesssageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Message')
          .document(chatId)
          .collection('Chat')
          .orderBy("time")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final messageData = snapshot.data.documents.reversed;
          List<MessageModel> messages = [];
          for (var message in messageData) {
            messages.add(MessageModel(
                delivered: message['delivered'],
                isMe: loginUser.email == message['sender'] ? false : true,
                message: message['message'],
                time: message['time']));
          }
          return ListView.builder(
            itemCount: messages.length,
            reverse: true,
            itemBuilder: (context, i) {
              return Bubble(
                delivered: messages[i].delivered,
                isMe: messages[i].isMe,
                message: messages[i].message,
                time: messages[i].time,
              );
            },
          );
        }
      },
    );
  }
}
