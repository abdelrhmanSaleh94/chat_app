import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String image;
  final String email;
  final String userId;

  UserModel(
      {@required this.name,
      @required this.image,
      @required this.email,
      @required this.userId});
}
