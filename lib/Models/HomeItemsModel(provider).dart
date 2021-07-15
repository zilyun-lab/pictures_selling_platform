// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'HomeItem(provider).dart';

class ItemGridModel extends ChangeNotifier {
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

  Future fetchPostCardItems() async {
    final snapshots = await FirebaseFirestore.instance
        .collection('items')
        .where("attribute", isEqualTo: "PostCard")
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

  Future fetchStickerItems() async {
    final snapshots = await FirebaseFirestore.instance
        .collection('items')
        .where("attribute", isEqualTo: "Sticker")
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

  Future fetchOriginalItems() async {
    final snapshots = await FirebaseFirestore.instance
        .collection('items')
        .where("attribute", isEqualTo: "Original")
        .snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final items = docs.map((doc) => Items(doc)).toList();
      this.items = items;
      notifyListeners();
    });
  }

  Future fetchCopyItems() async {
    final snapshots = await FirebaseFirestore.instance
        .collection('items')
        .where("attribute", isEqualTo: "Copy")
        .snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final items = docs.map((doc) => Items(doc)).toList();
      this.items = items;
      notifyListeners();
    });
  }
}
