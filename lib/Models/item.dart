// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
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
  int finalGetProceeds;
  String shipsPayment;
  String shipsDate;
  String paper;
  String howToCopy;
  String isFrame;
  String stockType;

  ItemModel({
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

  ItemModel.fromJson(Map<String, dynamic> json) {
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

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
