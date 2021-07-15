// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:selling_pictures_platform/Config/config.dart';
import 'UploadItemList.dart';

class UploadItemModel extends ChangeNotifier {
  //List<クラス名>　○○ = [];
  List<UploadItems> items = [];

  Future fetchItems() async {
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("MyUploadItems")
        .get();
    final items = docs.docs.map((doc) => UploadItems(doc)).toList();
    this.items = items;
    notifyListeners();
  }
}
