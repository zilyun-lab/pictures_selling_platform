// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class LikeItems {
  //クラス名(引数){
  // init内容
  // }
  LikeItems(QueryDocumentSnapshot doc) {
    shortInfo = doc['shortInfo'];
    thumbnailUrl = doc['thumbnailUrl'];
    price = doc["price"];
    longDescription = doc["longDescription"];
    attribute = doc["attribute"];
    postBy = doc["postBy"];
    Stock = doc["Stock"];
    id = doc["id"];
  }
  LikeItems.fromJson(Map<String, dynamic> json) {
    shortInfo = json['shortInfo'];
    longDescription = json['longDescription'];
    price = json['price'];

    thumbnailUrl = json['thumbnailUrl'];
    postBy = json['postBy'];
    attribute = json['attribute'];
    Stock = json['Stock'];
    id = json['id'];
  }

  String shortInfo;
  String thumbnailUrl;
  int price;
  String longDescription;
  String attribute;
  String postBy;
  int Stock;
  String id;
}
