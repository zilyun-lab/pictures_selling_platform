import 'package:cloud_firestore/cloud_firestore.dart';

class UploadItems {
  //クラス名(引数){
  // init内容
  // }
  UploadItems(QueryDocumentSnapshot doc) {
    shortInfo = doc['shortInfo'];
    longDescription = doc['longDescription'];
    price = doc['price'];
    publishedDate = doc['publishedDate'];
    status = doc['status'];
    thumbnailUrl = doc['thumbnailUrl'];
    postBy = doc['postBy'];
    attribute = doc['attribute'];
    Stock = doc['Stock'];
    id = doc['id'];
    color1 = doc['color1'];
    color2 = doc['color2'];
    postName = doc['postName'];
    itemWidth = doc['itemWidth'];
    itemHeight = doc['itemHeight'];
    finalGetProceeds = doc['finalGetProceeds'];
    shipsPayment = doc['shipsPayment'];
    shipsDate = doc['shipsDate'];
    paper = doc['paper'];
    howToCopy = doc['howToCopy'];
    isFrame = doc['isFrame'];
    stockType = doc['stockType'];
  }

  String shortInfo;
  String longDescription;
  int price;
  Timestamp publishedDate;
  String status;
  String thumbnailUrl;
  String postBy;
  String attribute;
  int Stock;
  String id;
  String color1;
  String color2;
  String postName;
  String itemWidth;
  String itemHeight;
  double finalGetProceeds;
  String shipsPayment;
  String shipsDate;
  String paper;
  String howToCopy;
  String isFrame;
  String stockType;
}
