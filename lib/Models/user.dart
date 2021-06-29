import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  User(DocumentSnapshot doc) {
    uid = doc["uid"];
    name = doc['name'];
    FaceBookURL = doc["FaceBookURL"];
    InstagramURL = doc["InstagramURL"];
    TwitterURL = doc["TwitterURL"];
    description = doc["description"];
    url = doc["url"];
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

class UserModel extends ChangeNotifier {
  //List<クラス名>　○○ = [];
  List<User> users = [];

  Future fetchItems() async {
    final snapshots =
        await FirebaseFirestore.instance.collection('users').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final users = docs.map((doc) => User(doc)).toList();
      this.users = users;
      notifyListeners();
    });
  }
}
