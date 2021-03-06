// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:selling_pictures_platform/Config/config.dart';
import 'like?temsList.dart';
import 'upload_item_list.dart';

class GetLikeItemsModel extends ChangeNotifier {
  //List<クラス名>　○○ = [];
  List<LikeItems> items = [];

  Future fetchItems() async {
    final snapshots = FirebaseFirestore.instance
        .collection('items')
        .where('id',
            whereIn: EcommerceApp.sharedPreferences
                .getStringList(EcommerceApp.userLikeList))
        .snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final items = docs.map((doc) => LikeItems(doc)).toList();
      this.items = items;
      notifyListeners();
    });
  }
}
