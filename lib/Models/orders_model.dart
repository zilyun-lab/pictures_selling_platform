// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  //クラス名(引数){
  // init内容
  // }
  Orders(QueryDocumentSnapshot doc) {
    CancelRequest = doc['CancelRequest'];
    CancelRequestTo = doc['CancelRequestTo'];
    addressID = doc['addressID'];
    boughtFrom = doc['boughtFrom'];
    buyerID = doc['buyerID'];
    cancelTransactionFinished = doc['cancelTransactionFinished'];
    email = doc['email'];
    finalGetProceeds = doc['finalGetProceeds'];
    id = doc['id'];
    imageURL = doc['imageURL'];
    isBuyerDelivery = doc['isBuyerDelivery'];
    itemID = doc['itemID'];
    isTransactionFinished = doc['isTransactionFinished'];
    itemPrice = doc['itemPrice'];
    orderBy = doc['orderBy'];
    orderByName = doc['orderByName'];
    orderTime = doc['orderTime'];
    productIDs = doc['productIDs'];
    sellerID = doc['sellerID'];
    totalPrice = doc['totalPrice'];
  }
  Orders.fromJson(Map<String, dynamic> json) {
    CancelRequest = json['CancelRequest'];
    CancelRequestTo = json['CancelRequestTo'];
    addressID = json['addressID'];
    boughtFrom = json['boughtFrom'];
    buyerID = json['buyerID'];
    cancelTransactionFinished = json['cancelTransactionFinished'];
    email = json['email'];
    finalGetProceeds = json['finalGetProceeds'];
    id = json['id'];
    imageURL = json['imageURL'];
    isBuyerDelivery = json['isBuyerDelivery'];
    itemID = json['itemID'];
    isTransactionFinished = json['isTransactionFinished'];
    itemPrice = json['itemPrice'];
    orderBy = json['orderBy'];
    orderByName = json['orderByName'];
    orderTime = json['orderTime'];
    productIDs = json['productIDs'];
    sellerID = json['sellerID'];
    totalPrice = json['totalPrice'];
  }

  bool CancelRequest;
  bool CancelRequestTo;
  String addressID;
  String boughtFrom;
  String buyerID;
  bool cancelTransactionFinished;
  String email;
  int finalGetProceeds;
  String id;
  String imageURL;
  String isBuyerDelivery;
  String isTransactionFinished;
  String itemID;
  int itemPrice;
  String orderBy;
  String orderByName;
  String orderTime;
  String productIDs;
  String sellerID;
  int totalPrice;
}
