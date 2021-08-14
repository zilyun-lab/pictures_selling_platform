// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:selling_pictures_platform/Config/config.dart';

class StarRating {
  //クラス名(引数){
  // init内容
  // }
  StarRating(DocumentSnapshot doc) {
    message = doc['message'];
    reviewDate = doc['reviewDate'];
    reviewBy = doc['reviewBy'];
    starRating = doc['starRating'];
  }

  String message;
  String reviewBy;
  double starRating;
  String reviewDate;
}

class StarRatingModel extends ChangeNotifier {
  //List<クラス名>　○○ = [];
  List<StarRating> items = [];
  final id;

  StarRatingModel({this.id});

  Future fetchItems() async {
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Review')
        .get();
    final items = docs.docs.map((doc) => StarRating(doc)).toList();
    this.items = items;
    notifyListeners();
  }
}
