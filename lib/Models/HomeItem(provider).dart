import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  //クラス名(引数){
  // init内容
  // }
  Items(QueryDocumentSnapshot doc) {
    documentID = doc.id;
    shortInfo = doc['shortInfo'];
    thumbnailUrl = doc['thumbnailUrl'];
    price = doc["price"];
    longDescription = doc["longDescription"];
    attribute = doc["attribute"];
    postBy = doc["postBy"];
    Stock = doc["Stock"];
    id = doc["id"];
    postName = doc["postName"];
  }

  String documentID;
  String shortInfo;
  String thumbnailUrl;
  int price;
  String longDescription;
  String attribute;
  String postBy;
  int Stock;
  String id;
  String postName;
}
