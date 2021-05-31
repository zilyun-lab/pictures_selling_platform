import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User(DocumentSnapshot doc) {
    documentID = doc.id;
    name = doc['name'];
  }

  String documentID;
  String name;
}