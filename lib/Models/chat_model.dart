// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  //クラス名(引数){
  // init内容
  // }
  Chat(QueryDocumentSnapshot doc) {
    created_at = doc['created_at'];
    message = doc['message'];
    myId = doc['myId'];
    orderID = doc['orderID'];
    user_name = doc['user_name'];
  }
  Chat.fromJson(Map<String, dynamic> json) {
    created_at = json['created_at'];
    message = json['message'];
    myId = json['myId'];
    orderID = json['orderID'];
    user_name = json['user_name'];
  }

  String created_at;
  String message;
  String myId;
  String orderID;
  String user_name;
}
