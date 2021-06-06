import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'HomeItem.dart';

class ItemGridModel extends ChangeNotifier {
  //List<クラス名>　○○ = [];
  List<Items> items = [];

  Future fetchItems() async {
    final docs = await FirebaseFirestore.instance
        .collection('items')
        .orderBy(
          "publishedDate",
          descending: true,
        )
        .get();
    final items = docs.docs.map((doc) => Items(doc)).toList();
    this.items = items;
    notifyListeners();
  }
}
