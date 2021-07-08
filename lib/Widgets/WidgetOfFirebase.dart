import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getData(
    String collection, String documentId) async {
  DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
      .collection(collection)
      .doc(documentId)
      .get();

  return docSnapshot.data();
}

Future<Map<String, dynamic>> getDataMultiple(String firstCollection,
    String firstDocumentId, String secondCollection, String secondDoc) async {
  DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
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

  CopyStickerPostCardModel({
    this.shortInfo,
    this.longDescription,
    this.price,
    this.publishedDate,
    this.status,
    this.thumbnailUrl,
    this.postBy,
    this.attribute,
    this.Stock,
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
    Stock = json['Stock'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shortInfo'] = this.shortInfo;
    data['longDescription'] = this.longDescription;
    data['price'] = this.price;
    data['publishedDate'] = this.publishedDate;
    data['status'] = this.status;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['postBy'] = this.postBy;
    data['attribute'] = this.attribute;
    data['Stock'] = this.Stock;
    data['id'] = this.id;
    data['color1'] = this.color1;
    data['color2'] = this.color2;
    data['postName'] = this.postName;
    data['itemWidth'] = this.itemWidth;
    data['itemHeight'] = this.itemHeight;
    data['finalGetProceeds'] = this.finalGetProceeds;
    data['shipsPayment'] = this.shipsPayment;
    data['shipsDate'] = this.shipsDate;
    data['paper'] = this.paper;
    data['howToCopy'] = this.howToCopy;
    data['isFrame'] = this.isFrame;
    data['stockType'] = this.stockType;
    return data;
  }
}
