import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  //クラス名(引数){
  // init内容
  // }
  Items(QueryDocumentSnapshot doc) {
    documentID = doc.id;
    shortInfo = doc['shortInfo'];
    thumbnailUrl = doc['thumbnailUrl'];
    //price = doc["price"];
  }

  String documentID;
  String shortInfo;
  String thumbnailUrl;
  //int price;
}
