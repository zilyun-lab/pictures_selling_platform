import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:selling_pictures_platform/Config/config.dart';

import 'LikeItemsList.dart';
import 'UploadItemList.dart';

class GetLikeItemsModel extends ChangeNotifier {
  //List<クラス名>　○○ = [];
  List<UploadItems> items = [];

  Future fetchItems() async {
    final snapshots = await EcommerceApp.firestore
        .collection("items")
        .where("shortInfo",
            whereIn: EcommerceApp.sharedPreferences
                .getStringList(EcommerceApp.userLikeList))
        .snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final items = docs.map((doc) => UploadItems(doc)).toList();
      this.items = items;
      notifyListeners();
    });
  }
}
