import 'package:flutter/foundation.dart';

class MessageModel {
  final String message, time;
  final bool delivered, isMe;

  MessageModel(
      {@required this.message,
      @required this.time,
      @required this.delivered,
      @required this.isMe});
}
