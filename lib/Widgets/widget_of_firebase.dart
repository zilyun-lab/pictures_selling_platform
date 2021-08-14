// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getData(
    String collection, String documentId) async {
  final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
      .collection(collection)
      .doc(documentId)
      .get();

  return docSnapshot.data();
}

Future<Map<String, dynamic>> getDataMultiple(String firstCollection,
    String firstDocumentId, String secondCollection, String secondDoc) async {
  final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
      .collection(firstCollection)
      .doc(firstDocumentId)
      .collection(secondCollection)
      .doc(secondDoc)
      .get();

  return docSnapshot.data();
}

void setData(String collection, Map data, String doc) {
  FirebaseFirestore.instance.collection(collection).doc(doc).set(data);
}

void setDataMultiple(
  String firstCollection,
  String firstDoc,
  String secondCollection,
  String secondDoc,
  Map data,
) {
  FirebaseFirestore.instance
      .collection(firstCollection)
      .doc(firstDoc)
      .collection(secondCollection)
      .doc(secondDoc)
      .set(data);
}

void updateData(String collection, Map data, {String doc}) {
  FirebaseFirestore.instance.collection(collection).doc(doc).update(data);
}

void updateDataMultiple(
  String firstCollection,
  String firstDoc,
  String secondCollection,
  String secondDoc,
  Map data,
) {
  FirebaseFirestore.instance
      .collection(firstCollection)
      .doc(firstDoc)
      .collection(secondCollection)
      .doc(secondDoc)
      .update(data);
}

Stream<QuerySnapshot> getStreamSnapshots(String collection) {
  return FirebaseFirestore.instance.collection(collection).snapshots();
}

Stream<DocumentSnapshot> getFirstStreamSnapshots(
    String collection, String doc) {
  return FirebaseFirestore.instance.collection(collection).doc(doc).snapshots();
}

Stream<QuerySnapshot> getSecondStreamSnapshots(
    String firstCollection, String doc, String secondCollection) {
  return FirebaseFirestore.instance
      .collection(firstCollection)
      .doc(doc)
      .collection(secondCollection)
      .snapshots();
}

Stream<DocumentSnapshot> getThirdStreamSnapshots(String firstCollection,
    String firstDoc, secondCollection, String secondDoc) {
  return FirebaseFirestore.instance
      .collection(firstCollection)
      .doc(firstDoc)
      .collection(secondCollection)
      .doc(secondDoc)
      .snapshots();
}

class CopyStickerPostCardModel {
  String shortInfo;
  String longDescription;
  int price;
  DateTime publishedDate;
  String status;
  String thumbnailUrl;
  String postBy;
  String attribute;
  int stock;
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

  CopyStickerPostCardModel({
    this.shortInfo,
    this.longDescription,
    this.price,
    this.publishedDate,
    this.status,
    this.thumbnailUrl,
    this.postBy,
    this.attribute,
    this.stock,
    this.id,
    this.color1,
    this.color2,
    this.postName,
    this.itemWidth,
    this.itemHeight,
    this.finalGetProceeds,
    this.shipsPayment,
    this.shipsDate,
    this.paper,
    this.howToCopy,
    this.isFrame,
    this.stockType,
  });

  CopyStickerPostCardModel.fromJson(Map<String, dynamic> json) {
    shortInfo = json['shortInfo'];
    longDescription = json['longDescription'];
    price = json['price'];
    publishedDate = json['publishedDate'];
    status = json['status'];
    thumbnailUrl = json['thumbnailUrl'];
    postBy = json['postBy'];
    attribute = json['attribute'];
    stock = json['Stock'];
    id = json['id'];
    color1 = json['color1'];
    color2 = json['color2'];
    postName = json['postName'];
    itemWidth = json['itemWidth'];
    itemHeight = json['itemHeight'];
    finalGetProceeds = json['finalGetProceeds'];
    shipsPayment = json['shipsPayment'];
    shipsDate = json['shipsDate'];
    paper = json['paper'];
    howToCopy = json['howToCopy'];
    isFrame = json['isFrame'];
    stockType = json['stockType'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['shortInfo'] = shortInfo;
    data['longDescription'] = longDescription;
    data['price'] = price;
    data['publishedDate'] = publishedDate;
    data['status'] = status;
    data['thumbnailUrl'] = thumbnailUrl;
    data['postBy'] = postBy;
    data['attribute'] = attribute;
    data['Stock'] = stock;
    data['id'] = id;
    data['color1'] = color1;
    data['color2'] = color2;
    data['postName'] = postName;
    data['itemWidth'] = itemWidth;
    data['itemHeight'] = itemHeight;
    data['finalGetProceeds'] = finalGetProceeds;
    data['shipsPayment'] = shipsPayment;
    data['shipsDate'] = shipsDate;
    data['paper'] = paper;
    data['howToCopy'] = howToCopy;
    data['isFrame'] = isFrame;
    data['stockType'] = stockType;
    return data;
  }
}
