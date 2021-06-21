import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'HomeItem(provider).dart';

class ItemGridModel extends ChangeNotifier {
  //List<クラス名>　○○ = [];
  List<Items> items = [];

  Future fetchItems() async {
    final snapshots = await FirebaseFirestore.instance
        .collection('items')
        .orderBy(
          "publishedDate",
          descending: true,
        )
        .snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final items = docs.map((doc) => Items(doc)).toList();
      this.items = items;
      notifyListeners();
    });
  }
}
