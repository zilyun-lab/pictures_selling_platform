// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User(DocumentSnapshot doc) {
    uid = doc['uid'];
    name = doc['name'];
    FaceBookURL = doc['FaceBookURL'];
    InstagramURL = doc['InstagramURL'];
    TwitterURL = doc['TwitterURL'];
    description = doc['description'];
    url = doc['url'];
  }

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    FaceBookURL = json['FaceBookURL'];
    InstagramURL = json['InstagramURL'];
    TwitterURL = json['TwitterURL'];
    description = json['description'];
    url = json['url'];
  }

  String documentID;
  String name;
  String FaceBookURL;
  String InstagramURL;
  String TwitterURL;
  String description;
  String uid;
  String url;
}
