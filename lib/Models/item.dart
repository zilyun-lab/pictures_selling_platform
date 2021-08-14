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
    final data = <String, dynamic>{};
    data['shortInfo'] = shortInfo;
    data['longDescription'] = longDescription;
    data['price'] = price;
    data['publishedDate'] = publishedDate;
    data['status'] = status;
    data['thumbnailUrl'] = thumbnailUrl;
    data['postBy'] = postBy;
    data['attribute'] = attribute;
    data['Stock'] = Stock;
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

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[date] = date;
    return data;
  }
}
